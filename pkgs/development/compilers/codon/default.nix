{ cacert
, cmake
, fetchFromGitHub
, git
, lib
, lld
, ninja
, nix-update-script
, perl
, python3
, stdenv
}:

let
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "exaloop";
    repo = "codon";
    rev = "v${version}";
    sha256 = "sha256-/IUGX5iSRvZzwyRdkGe0IVHp44D+GXZtbkdtswekwSU=";
  };

  depsDir = "deps";

  codon-llvm = stdenv.mkDerivation {
    pname = "codon-llvm";
    version = "unstable-2022-09-23";

    src = fetchFromGitHub {
      owner = "exaloop";
      repo = "llvm-project";
      rev = "55b0b8fa1c9f9082b535628fc9fa6313280c0b9a";
      sha256 = "sha256-03SPQgNdrpR6/JZ5aR/ntoh/FnZvCjT/6bTAcZaFafw=";
    };

    nativeBuildInputs = [
      cmake
      git
      lld
      ninja
      python3
    ];

    cmakeFlags = [
      "-DCMAKE_CXX_COMPILER=clang++"
      "-DCMAKE_C_COMPILER=clang"
      "-DLLVM_ENABLE_RTTI=ON"
      "-DLLVM_ENABLE_TERMINFO=OFF"
      "-DLLVM_ENABLE_ZLIB=OFF"
      "-DLLVM_INCLUDE_TESTS=OFF"
      "-DLLVM_TARGETS_TO_BUILD=all"
      "-DLLVM_USE_LINKER=lld"
      "-S ../llvm"
    ];
  };

  codon-deps = stdenv.mkDerivation {
    name = "codon-deps-${version}.tar.gz";

    inherit src;

    nativeBuildInputs = [
      cacert
      cmake
      git
      perl
      python3
    ];

    dontBuild = true;

    cmakeFlags = [
      "-DCPM_DOWNLOAD_ALL=ON"
      "-DCPM_SOURCE_CACHE=${depsDir}"
      "-DLLVM_DIR=${codon-llvm}/lib/cmake/llvm"
    ];

    installPhase = ''
      # Prune the `.git` directories
      find ${depsDir} -name .git -type d -prune -exec rm -rf {} \;;
      # Build a reproducible tar, per instructions at https://reproducible-builds.org/docs/archives/
      tar --owner=0 --group=0 --numeric-owner --format=gnu \
          --sort=name --mtime="@$SOURCE_DATE_EPOCH" \
          -czf $out \
            ${depsDir} \
            cmake \
            _deps/googletest-subbuild/googletest-populate-prefix/src/*.zip
    '';

    outputHash = "sha256-a1zGSpbMjfQBrcgW/aiIdKX8+uI3p/S9pgZjHe2HtWs=";
    outputHashAlgo = "sha256";
  };
in
stdenv.mkDerivation {
  pname = "codon";

  inherit src version;

  patches = [
    # Without the hash, CMake will try to replace the `.zip` file
    ./Add-a-hash-to-the-googletest-binary.patch
  ];

  nativeBuildInputs = [
    cmake
    git
    lld
    ninja
    perl
    python3
  ];

  postUnpack = ''
    mkdir -p $sourceRoot/build
    tar -xf ${codon-deps} -C $sourceRoot/build
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_COMPILER=clang++"
    "-DCMAKE_C_COMPILER=clang"
    "-DCPM_SOURCE_CACHE=${depsDir}"
    "-DLLVM_DIR=${codon-llvm}/lib/cmake/llvm"
    "-DLLVM_USE_LINKER=lld"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A high-performance, zero-overhead, extensible Python compiler using LLVM";
    homepage = "https://docs.exaloop.io/codon";
    maintainers = [ lib.maintainers.paveloom ];
    license = lib.licenses.bsl11;
    platforms = lib.platforms.all;
  };
}
