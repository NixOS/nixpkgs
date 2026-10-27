{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "sedparse";
  version = "0.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aureliojargas";
    repo = "sedparse";
    rev = "0.1.2";
    hash = "sha256-Q17A/oJ3GZbdSK55hPaMdw85g43WhTW9tuAuJtDfHHU=";
  };

  meta = {
    description = "Python port of GNU sed's parser";
    homepage = "https://github.com/aureliojargas/sedparse";
    license = lib.licenses.gpl3Plus;
  };
}
