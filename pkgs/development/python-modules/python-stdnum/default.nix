{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, zeep
}:

buildPythonPackage rec {
  pname = "python-stdnum";
<<<<<<< HEAD
  version = "1.19";
=======
  version = "1.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Ez7IL1Y5DqdMGQVp6Y8vsUuGmAix1UeFcI8i0P6tiz8=";
=======
    hash = "sha256-vMdj2cSa4j2l0remhtX9He7J2QUTQRYKENGscjomvsA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
