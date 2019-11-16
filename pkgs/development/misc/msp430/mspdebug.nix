{ stdenv, fetchFromGitHub, libusb, readline ? null }:

let
  version = "0.25";
in stdenv.mkDerivation {
  pname = "mspdebug";
  inherit version;
  src = fetchFromGitHub {
    owner = "dlbeer";
    repo = "mspdebug";
    rev = "v${version}";
    sha256 = "0prgwb5vx6fd4bj12ss1bbb6axj2kjyriyjxqrzd58s5jyyy8d3c";
  };

  buildInputs = [ libusb readline ];
  makeFlags = [ "PREFIX=$(out)" "INSTALL=install" ] ++
    (if readline == null then [ "WITHOUT_READLINE=1" ] else []);

  meta = with stdenv.lib; {
    description = "A free programmer, debugger, and gdb proxy for MSP430 MCUs";
    homepage = https://dlbeer.co.nz/mspdebug/;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ aerialx ];
  };
}
