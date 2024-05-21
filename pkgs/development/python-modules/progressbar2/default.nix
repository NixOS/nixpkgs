{ lib
, buildPythonPackage
, fetchPypi
, dill
, freezegun
, pytestCheckHook
, python-utils
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "4.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P9ouDGBpNgCmWFp4TJ07xOHaxX6Z4TP4wPXIzz3zdKI=";
  };

  postPatch = ''
    sed -i "/-cov/d" pytest.ini
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    python-utils
  ];

  nativeCheckInputs = [
    dill
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "progressbar"
  ];

  meta = with lib; {
    description = "Text progressbar library";
    homepage = "https://progressbar-2.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
