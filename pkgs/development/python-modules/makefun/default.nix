{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "makefun";
  version = "1.15.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n5uZBOfDl3WTdKiPTFd4H7qypFjex430s+5ics2fsBA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "makefun" ];

  meta = with lib; {
    homepage = "https://github.com/smarie/python-makefun";
    description = "Small library to dynamically create python functions";
    license = licenses.bsd2;
    maintainers = with maintainers; [ veehaitch ];
  };
}
