{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  jaraco-classes,
  more-itertools,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jaraco-functools";
  version = "4.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jaraco_functools";
    inherit version;
    hash = "sha256-2iGTOwQXuJUVViZWVHp3tJMfmBdusXNkTA01Ayoz1rs=";
  };

  postPatch = ''
    sed -i "/coherent\.licensed/d" pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ more-itertools ];

  nativeCheckInputs = [
    jaraco-classes
    pytestCheckHook
  ];

  # test is flaky on darwin
  disabledTests = if stdenv.hostPlatform.isDarwin then [ "test_function_throttled" ] else null;

  pythonNamespaces = [ "jaraco" ];

  pythonImportsCheck = [ "jaraco.functools" ];

  meta = {
    description = "Additional functools in the spirit of stdlib's functools";
    homepage = "https://github.com/jaraco/jaraco.functools";
    changelog = "https://github.com/jaraco/jaraco.functools/blob/v${version}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
