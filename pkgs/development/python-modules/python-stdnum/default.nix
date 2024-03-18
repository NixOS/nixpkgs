{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, zeep
}:

buildPythonPackage rec {
  pname = "python-stdnum";
  version = "1.20";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rSos8usCXeQIIQI182tK4xJS3jGGJAzKqBJuEXy4JpA=";
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
