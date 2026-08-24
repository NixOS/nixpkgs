{
  lib,
  buildPythonPackage,
  fetchPypi,
  dill,
  freezegun,
  pytestCheckHook,
  python-utils,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "4.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/kjIlVqEQor3e/8mQrpHBB4bj3yGelt8yU+LwlWo8M8=";
  };

  postPatch = ''
    sed -i "/-cov/d" pytest.ini
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ python-utils ];

  nativeCheckInputs = [
    dill
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "progressbar" ];

  meta = {
    description = "Text progressbar library";
    homepage = "https://progressbar-2.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
