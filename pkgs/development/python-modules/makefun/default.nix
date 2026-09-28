{
  lib,
  fetchPypi,
  buildPythonPackage,

  # build-system
  setuptools_80,
  setuptools-scm,

  # tests
  pytest8_3CheckHook,
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
    setuptools_80
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest8_3CheckHook
  ];

  pythonImportsCheck = [ "makefun" ];

  meta = {
    homepage = "https://github.com/smarie/python-makefun";
    description = "Small library to dynamically create python functions";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
}
