{ stdenv, fetchurl, pkgconfig, python, cmocka, hexdump, writeScriptBin, binutils-unwrapped }:

stdenv.mkDerivation rec {
  pname = "unicorn-emulator";
  version = "1.0.2-rc4";

  src = fetchurl {
    url    = "https://github.com/unicorn-engine/unicorn/archive/${version}.tar.gz";
    sha256 = "05w43jq3r97l3c8ggc745ai8m5l93p1b6q6cfp1zwzz6hl5kifiv";
  };

  PREFIX = placeholder "out";
  MACOS_UNIVERSAL = stdenv.lib.optionalString stdenv.isDarwin "no";
  NIX_CFLAGS_COMPILE = "-Wno-error";

  doCheck = !stdenv.isDarwin;

  checkInputs = [
    cmocka
    hexdump
    python.pkgs.setuptools
  ];

  nativeBuildInputs = [ pkgconfig python ];
  enableParallelBuilding = true;

  meta = {
    description = "Lightweight multi-platform CPU emulator library";
    homepage    = "http://www.unicorn-engine.org";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
