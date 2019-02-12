{ lib
, buildPythonPackage
, fetchurl
, bottle
, isPy3k
}:

buildPythonPackage rec {
  pname = "grammalecte";
  version = "0.6.5";

  src = fetchurl {
    url = "http://www.dicollecte.org/grammalecte/zip/Grammalecte-fr-v${version}.zip";
    sha256 = "11byjs3ggdhia5f4vyfqfvbbczsfqimll98h98g7hlsrm7vrifb0";
  };

  propagatedBuildInputs = [ bottle ];

  preBuild = "cd ..";

  disabled = !isPy3k;

  meta = {
    description = "Grammalecte is an open source grammar checker for the French language";
    homepage = https://grammalecte.net;
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ apeyroux ];
  };
}
