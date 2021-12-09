{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pythonOlder
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "exdown";
  version = "0.9.0";
  format = "pyproject";

  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "nschloe";
     repo = "exdown";
     rev = "v0.9.0";
     sha256 = "1i74py33pvmg0517b1028xa0d18nw7pfqr38k32lgigksmc091fc";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "exdown" ];

  meta = with lib; {
    description = "Extract code blocks from markdown";
    homepage = "https://github.com/nschloe/exdown";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
