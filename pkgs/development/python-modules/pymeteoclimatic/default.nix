{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, lxml
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pymeteoclimatic";
  version = "0.1.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "adrianmo";
    repo = pname;
    rev = version;
    sha256 = "sha256-rP0+OYDnQ4GuoV7DzR6jtgH6ilTMLjdaEFJcz3L0GYQ=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "meteoclimatic" ];

  meta = with lib; {
    description = "Python wrapper around the Meteoclimatic service";
    homepage = "https://github.com/adrianmo/pymeteoclimatic";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
