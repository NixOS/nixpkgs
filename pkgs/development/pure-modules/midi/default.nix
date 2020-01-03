{ stdenv, fetchurl, pkgconfig, pure, portmidi }:

stdenv.mkDerivation rec {
  baseName = "midi";
  version = "0.6";
  name = "pure-${baseName}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/purelang/pure-lang/downloads/${name}.tar.gz";
    sha256 = "817ae9fa5f443a8c478a6770f36091e3cf99f3515c74e00d09ca958dead1e7eb";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ pure portmidi ];
  makeFlags = [ "libdir=$(out)/lib" "prefix=$(out)/" ];
  setupHook = ../generic-setup-hook.sh;

  meta = {
    description = "A MIDI interface for the Pure programming language";
    homepage = http://puredocs.bitbucket.org/pure-midi.html;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ asppsa ];
  };
}
