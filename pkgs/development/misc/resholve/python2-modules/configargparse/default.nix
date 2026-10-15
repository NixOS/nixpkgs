{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "configargparse";
  version = "1.5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bw2";
    repo = "ConfigArgParse";
    rev = "v${version}";
    hash = "sha256-n771PgQoAzArdSL0fSnhU5EJvujNcZ18XOJOGheJSrc=";
  };

  doCheck = false;

  pythonImportsCheck = [ "configargparse" ];

  meta = {
    description = "Drop-in replacement for argparse";
    homepage = "https://github.com/bw2/ConfigArgParse";
    license = lib.licenses.mit;
  };
}
