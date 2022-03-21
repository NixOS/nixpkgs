{ lib, stdenv, fetchurl, pkg-config, pure, portmidi }:

stdenv.mkDerivation rec {
  pname = "pure-midi";
  version = "0.6";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/pure-midi-${version}.tar.gz";
    sha256 = "817ae9fa5f443a8c478a6770f36091e3cf99f3515c74e00d09ca958dead1e7eb";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ pure portmidi ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A MIDI interface for the Pure programming language";
    homepage = "http://puredocs.bitbucket.org/pure-midi.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asppsa ];
  };
}
