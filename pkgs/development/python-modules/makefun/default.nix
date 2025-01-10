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
  version = "1.15.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JrxjRCphgvt17+2LUXQd0tHbLxdr7Ixk4gpYYla48Uk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools>=39.2,<72"' '"setuptools"'
  '';

  build-system = [
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
