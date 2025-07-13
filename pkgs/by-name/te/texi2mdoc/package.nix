{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "texi2mdoc";
  version = "0.1.2";

  src = fetchurl {
    url = "https://mdocml.bsd.lv/texi2mdoc/snapshots/texi2mdoc-${version}.tgz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "http://mdocml.bsd.lv/";
    description = "converter from Texinfo into mdoc";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ ramkromberg ];
    mainProgram = "texi2mdoc";
  };
}
