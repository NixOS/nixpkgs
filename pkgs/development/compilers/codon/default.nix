{ lib
, stdenv

, cacert
, cmake
, fetchFromGitHub
, gcc
, git
, ninja
, nix-update-script
, perl
, python3
, runCommand
, zlib
}:

let
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "exaloop";
    repo = "codon";
    rev = "v${version}";
    hash = "sha256-cfdb/DxrLS3F4MK31l/17j/R6IWlh85blWEsLDqDCDI=";
  };

  depsDir = "deps";

  codon-llvm = stdenv.mkDerivation {
    pname = "codon-llvm";
    version = "unstable-2022-09-23";

    src = fetchFromGitHub {
      owner = "exaloop";
      repo = "llvm-project";
      rev = "55b0b8fa1c9f9082b535628fc9fa6313280c0b9a";
      hash = "sha256-03SPQgNdrpR6/JZ5aR/ntoh/FnZvCjT/6bTAcZaFafw=";
    };

    nativeBuildInputs = [
      cmake
      git
      ninja
      python3
    ];

    cmakeFlags = [
      "-DLLVM_ENABLE_RTTI=ON"
      "-DLLVM_ENABLE_TERMINFO=OFF"
      "-DLLVM_ENABLE_ZLIB=OFF"
      "-DLLVM_INCLUDE_TESTS=OFF"
      "-DLLVM_TARGETS_TO_BUILD=all"
      "-S ../llvm"
    ];
  };

  codon-deps = stdenv.mkDerivation {
    name = "codon-deps.tar.gz";

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

    outputHash =
      if stdenv.hostPlatform.isDarwin then
        "sha256-KfemYV42xBAhsPbwTkzdc3GxCVHiWRbyUZORPWxx4vg="
      else
        "sha256-a1zGSpbMjfQBrcgW/aiIdKX8+uI3p/S9pgZjHe2HtWs=";
  };
in
stdenv.mkDerivation {
  pname = "codon";

  inherit src version;

  patches = [
    # Without the hash, CMake will try to replace the `.zip` file
    ./Add-a-hash-to-the-googletest-binary.patch
    # Make sure `CXX` calls can find the shared libraries
    (runCommand "Add-run-time-search-paths-and-override-the-CXX-compiler.patch"
      {
        CXX = "${gcc}/bin/c++";
        NIX_RPATHS = lib.concatStringsSep ", "
          (map (s: "\"" + s + "/lib\"") (map lib.getLib [ zlib ]));
      }
      ''
        substitute \
          ${./Add-run-time-search-paths-and-override-the-CXX-compiler.patch} \
          $out \
          --subst-var CXX \
          --subst-var NIX_RPATHS \
      '')
  ];

  nativeBuildInputs = [
    cmake
    git
    ninja
    perl
    python3
  ];

  depsHostHost = [
    # Compiling to executable with optimizations enabled fails without it
    gcc
  ];

  cmakeFlags = [
    "-DCPM_SOURCE_CACHE=${depsDir}"
    "-DLLVM_DIR=${codon-llvm}/lib/cmake/llvm"
  ];

  postUnpack = ''
    mkdir -p $sourceRoot/build
    tar -xf ${codon-deps} -C $sourceRoot/build
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/codon/*.dylib $out/lib/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A high-performance, zero-overhead, extensible Python compiler using LLVM";
    homepage = "https://docs.exaloop.io/codon";
    maintainers = [ lib.maintainers.paveloom ];
    license = lib.licenses.bsl11;
    platforms = lib.platforms.all;
  };
}
