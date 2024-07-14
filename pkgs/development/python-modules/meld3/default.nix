{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "meld3";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PqJmmU8aqDUHZ5pntJO4UsIyp5BeKUQKa4aFWMrV53U=";
  };

  doCheck = false;

  meta = with lib; {
    description = "HTML/XML templating engine used by supervisor";
    homepage = "https://github.com/supervisor/meld3";
    license = licenses.free;
  };
}
