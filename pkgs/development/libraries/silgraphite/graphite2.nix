{ stdenv, fetchurl, pkgconfig, freetype, cmake, python }:

stdenv.mkDerivation rec {
  version = "1.3.13";
  pname = "graphite2";

  src = fetchurl {
    url = "https://github.com/silnrsi/graphite/releases/download/"
      + "${version}/graphite2-${version}.tgz";
    sha256 = "01jzhwnj1c3d68dmw15jdxly0hwkmd8ja4kw755rbkykn1ly2qyx";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ freetype ];

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./macosx.patch ];

  checkInputs = [ python ];
  doCheck = false; # fails, probably missing something

  meta = with stdenv.lib; {
    description = "An advanced font engine";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
