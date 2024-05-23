{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sacn";
  version = "1.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ppXWRBZVm4QroxZ19S388sRuI5zpaDgJrJqhnwefr3k=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "sacn" ];

  meta = with lib; {
    description = "A simple ANSI E1.31 (aka sACN) module";
    homepage = "https://github.com/Hundemeier/sacn";
    changelog = "https://github.com/Hundemeier/sacn/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
