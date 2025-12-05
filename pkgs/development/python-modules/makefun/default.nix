{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "makefun";
  version = "1.16.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4UYBgxVwv/H21+aIKLzTDS9YVvJLrV3gzLIpIc7ryUc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools>=39.2,<72"' '"setuptools"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytest7CheckHook ];

  pythonImportsCheck = [ "makefun" ];

  meta = with lib; {
    homepage = "https://github.com/smarie/python-makefun";
    description = "Small library to dynamically create python functions";
    license = licenses.bsd2;
    maintainers = with maintainers; [ veehaitch ];
  };
}
