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
  version = "0.0.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "adrianmo";
    repo = pname;
    rev = version;
    sha256 = "0ys0d6jy7416gbsd0pqgvm5ygzn36pjdaklqi4q56vsb13zn7y0h";
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
