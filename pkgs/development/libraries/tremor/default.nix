{ stdenv, fetchsvn, autoreconfHook, pkgconfig, libogg }:

stdenv.mkDerivation rec {
  name = "tremor-svn-${src.rev}";

  src = fetchsvn {
    url = http://svn.xiph.org/trunk/Tremor;
    rev = "17866";
    sha256 = "161411cbefa1527da7a8fc087e78d8e21d19143d3a6eb42fb281e5026aad7568";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  propagatedBuildInputs = [ libogg ];

  preConfigure = ''
    sed -i /XIPH_PATH_OGG/d configure
  '';

  meta = {
    homepage = http://xiph.org/tremor/;
    description = "Fixed-point version of the Ogg Vorbis decoder";
    license = stdenv.lib.licenses.bsd3;
  };
}
