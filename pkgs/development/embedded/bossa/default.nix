{ lib
, stdenv
, fetchFromGitHub
, wxGTK32
, libX11
, readline
, darwin
, fetchpatch
}:

let
  # BOSSA needs a "bin2c" program to embed images.
  # Source taken from:
  # http://wiki.wxwidgets.org/Embedding_PNG_Images-Bin2c_In_C
  bin2c = stdenv.mkDerivation {
    name = "bossa-bin2c";
    src = ./bin2c.c;
    dontUnpack = true;
    buildPhase = "cc $src -o bin2c";
    installPhase = "mkdir -p $out/bin; cp bin2c $out/bin/";
  };

in
stdenv.mkDerivation rec {
  pname = "bossa";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "shumatech";
    repo = "BOSSA";
    rev = version;
    sha256 = "sha256-8M3MU/+Y1L6SaQ1yoC9Z27A/gGruZdopLnL1z7h7YJw=";
  };

  patches = [
    (fetchpatch {
      # Required for building on Darwin with clang >=15.
      name = "pr-172-fix.patch";
      url = "https://github.com/shumatech/BOSSA/commit/6e54973c3c758674c3d04b5e2cf12e097006f6a3.patch";
      hash = "sha256-2lp6Ej3IfofztC1n/yHLjabn0MH4BA/CM3dsnAw8klA=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "-arch x86_64" ""
  '';

  nativeBuildInputs = [ bin2c ];
  buildInputs = [
    wxGTK32
    libX11
    readline
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
  ];

  makeFlags = [
    "WXVERSION=3.2"
    # Explicitly specify targets so they don't get stripped.
    "bin/bossac"
    "bin/bossash"
    "bin/bossa"
  ];
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  installPhase = ''
    mkdir -p $out/bin
    cp bin/bossa{c,sh,} $out/bin/
  '';

  meta = with lib; {
    description = "Flash programming utility for Atmel's SAM family of flash-based ARM microcontrollers";
    longDescription = ''
      BOSSA is a flash programming utility for Atmel's SAM family of
      flash-based ARM microcontrollers. The motivation behind BOSSA is
      to create a simple, easy-to-use, open source utility to replace
      Atmel's SAM-BA software. BOSSA is an acronym for Basic Open
      Source SAM-BA Application to reflect that goal.
    '';
    homepage = "http://www.shumatech.com/web/products/bossa";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
