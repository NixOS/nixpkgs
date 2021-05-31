{ lib
, fetchFromGitHub
, cmake
, llvmPackages
, libxml2
, zlib
, fetchpatch
}:

let
  inherit (llvmPackages) stdenv;
in
stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    hash = "sha256-bILjcKX8jPl2n1HRYvYRb7jJkobwqmSJ+hHXSn9n2ag=";
  };

  patches = [
    # glibc 2.33 support
    (fetchpatch {
      url = "https://github.com/ziglang/zig/commit/0fee4b55a8c58791238efe6bf2da5ce3435a5cc1.patch";
      sha256 = "sha256-waVtolUlmGrfiRk4tWsSOij5MfUc+g57DatC6GtSx6c=";
    })
  ];

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm.dev
  ];
  buildInputs = [
    libxml2
    zlib
  ] ++ (with llvmPackages; [
    libclang
    lld
    llvm
  ]);

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://ziglang.org/";
    description =
      "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewrk AndersonTorres ];
    platforms = platforms.unix;
    # See https://github.com/NixOS/nixpkgs/issues/86299
    broken = stdenv.isDarwin;
  };
}

