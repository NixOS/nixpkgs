{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, zeep
}:

buildPythonPackage rec {
  pname = "python-stdnum";
  version = "1.19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ez7IL1Y5DqdMGQVp6Y8vsUuGmAix1UeFcI8i0P6tiz8=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=stdnum --cov-report=term-missing:skip-covered --cov-report=html" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    SOAP = [
      zeep
    ];
  };

  pythonImportsCheck = [
    "stdnum"
  ];

  meta = with lib; {
    description = "Python module to handle standardized numbers and codes";
    homepage = "https://arthurdejong.org/python-stdnum/";
    changelog = "https://github.com/arthurdejong/python-stdnum/blob/${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ johbo ];
  };
}
