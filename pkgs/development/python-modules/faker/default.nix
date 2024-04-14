{ lib
, buildPythonPackage
, fetchPypi
, freezegun
, pillow
, pytestCheckHook
, python-dateutil
, setuptools
, text-unidecode
, ukpostcodeparser
, validators
}:

buildPythonPackage rec {
  pname = "faker";
  version = "24.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "Faker";
    inherit version;
    hash = "sha256-6m94TEBzDeD3cGfknnjN1ZDvsAvsPTP1d0kiYiBsF/w=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    python-dateutil
    text-unidecode
  ];

  nativeCheckInputs = [
    freezegun
    pillow
    pytestCheckHook
    ukpostcodeparser
    validators
  ];

  # avoid tests which import random2, an abandoned library
  pytestFlagsArray = [
    "--ignore=tests/providers/test_ssn.py"
  ];
  pythonImportsCheck = [ "faker" ];

  meta = with lib; {
    description = "Python library for generating fake user data";
    mainProgram = "faker";
    homepage = "http://faker.rtfd.org";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
  };
}
