{ lib
, stdenv
, fetchFromGitHub
, cmake
, coreutils
, llvmPackages
, libxml2
, zlib
}:

stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    hash = "sha256-69QIkkKzApOGfrBdgtmxFMDytRkSh+0YiaJQPbXsBeo=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm.dev
  ];

  buildInputs = [
    coreutils
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

  postPatch = ''
    # Zig's build looks at /usr/bin/env to find dynamic linking info. This
    # doesn't work in Nix' sandbox. Use env from our coreutils instead.
    substituteInPlace lib/std/zig/system/NativeTargetInfo.zig --replace "/usr/bin/env" "${coreutils}/bin/env"
  '';

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  doCheck = true;
  installCheckPhase = ''
    $out/bin/zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
  '';

  meta = with lib; {
    homepage = "https://ziglang.org/";
    description =
      "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    license = licenses.mit;
    maintainers = with maintainers; [ aiotter andrewrk AndersonTorres ];
    platforms = platforms.unix;
    # Build fails on Darwin on both AArch64 and x86_64:
    # https://github.com/NixOS/nixpkgs/pull/210324#issuecomment-1381313616
    # https://github.com/NixOS/nixpkgs/pull/210324#issuecomment-1381236045
    broken = stdenv.isDarwin;
  };
}
