{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, alarmdecoder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "adext";
  version = "0.4.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ajschmidt8";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-y8BvcSc3vD0FEWiyzW2Oh6PBS2Itjs2sz+9Dzh5yqSg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    alarmdecoder
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "adext" ];

  meta = with lib; {
    description = "Python extension for AlarmDecoder";
    homepage = "https://github.com/ajschmidt8/adext";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
