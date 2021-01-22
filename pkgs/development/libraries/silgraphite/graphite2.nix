{ lib, stdenv, fetchurl, pkg-config, freetype, cmake, python }:

stdenv.mkDerivation rec {
  version = "1.3.14";
  pname = "graphite2";

  src = fetchurl {
    url = "https://github.com/silnrsi/graphite/releases/download/"
      + "${version}/graphite2-${version}.tgz";
    sha256 = "1790ajyhk0ax8xxamnrk176gc9gvhadzy78qia4rd8jzm89ir7gr";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ freetype ];

  patches = lib.optionals stdenv.isDarwin [ ./macosx.patch ];

  checkInputs = [ python ];
  doCheck = false; # fails, probably missing something

  meta = with lib; {
    description = "An advanced font engine";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.lgpl21;
  };
}
