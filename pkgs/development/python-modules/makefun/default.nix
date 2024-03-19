{ lib
, fetchPypi
, buildPythonPackage

# build-system
, setuptools
, setuptools-scm

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "makefun";
  version = "1.15.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FvKis02e4MK1eMlgoYCMl04oIs959um5xFWqzhCILUU=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "makefun" ];

  meta = with lib; {
    homepage = "https://github.com/smarie/python-makefun";
    description = "Small library to dynamically create python functions";
    license = licenses.bsd2;
    maintainers = with maintainers; [ veehaitch ];
  };
}
