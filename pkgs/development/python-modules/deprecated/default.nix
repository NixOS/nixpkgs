{ lib
, fetchPypi
, buildPythonPackage
, wrapt
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deprecated";
  version = "1.2.13";

  src = fetchPypi {
    pname = "Deprecated";
    inherit version;
    hash = "sha256-Q6xTNdqQwxwkugKK9TapHUHVP55pAd2wIbzFcs5E440=";
  };

  propagatedBuildInputs = [
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "deprecated" ];

  meta = with lib; {
    homepage = "https://github.com/tantale/deprecated";
    description = "Python @deprecated decorator to deprecate old python classes, functions or methods";
    license = licenses.mit;
    maintainers = with maintainers; [ tilpner ];
  };
}
