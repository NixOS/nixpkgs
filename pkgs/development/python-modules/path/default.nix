{
  lib,
  buildPythonPackage,
  fetchPypi,
  more-itertools,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "path";
  version = "17.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lfy/7ItNlg80acUqzxMxE8KovxKse5jWKfqRr4ckjUI=";
  };

  postPatch = ''
    sed -i "/coherent\.licensed/d" pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    more-itertools
    pytestCheckHook
  ];

  disabledTests = [
    # creates a file, checks when it was last accessed/modified
    # AssertionError: assert 1650036414.0 == 1650036414.960688
    "test_utime"
  ];

  pythonImportsCheck = [ "path" ];

  meta = {
    description = "Object-oriented file system path manipulation";
    homepage = "https://github.com/jaraco/path";
    changelog = "https://github.com/jaraco/path/blob/v${version}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
