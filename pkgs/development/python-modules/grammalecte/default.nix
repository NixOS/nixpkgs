{ lib
, buildPythonPackage
, fetchurl
, bottle
, isPy3k
}:

buildPythonPackage rec {
  pname = "grammalecte";
  version = "0.6.1";

  src = fetchurl {
    url = "http://www.dicollecte.org/grammalecte/zip/Grammalecte-fr-v${version}.zip";
    sha256 = "0y2ck6pkd2p3cbjlxxvz3x5rnbg3ghfx97n13302rnab66cy4zkh";
  };

  propagatedBuildInputs = [ bottle ];

  preBuild = "cd ..";
  postInstall = ''
    rm $out/bin/bottle.py
  '';

  disabled = !isPy3k;

  meta = {
    description = "Grammalecte is an open source grammar checker for the French language";
    homepage = https://dicollecte.org/grammalecte/;
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ apeyroux ];
  };
}
