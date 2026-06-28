{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  cython,
  setuptools,

  # buildInputs
  libffi,
  pytestCheckHook,
  clang,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyobjus";
  version = "1.2.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kivy";
    repo = "pyobjus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rKMaXvUNdl8/wlDCQPGccQljnaCBSv/P68f7X1xOe0o=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [
    libffi
  ];

  pythonImportsCheck = [ "pyobjus" ];

  preCheck = ''
    rm -rf pyobjus
    make test_lib
    mkdir -p $out/${python.sitePackages}/objc_classes
    mv objc_classes/test $out/${python.sitePackages}/objc_classes
  '';

  postCheck = ''
    rm -rf $out/${python.sitePackages}/objc_classes/test
  '';

  nativeCheckInputs = [
    clang
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: False is not true
    "test_multiple_delegates"
  ];

  meta = {
    changelog = "https://github.com/kivy/pyobjus/releases/tag/v${finalAttrs.version}";
    description = "Access Objective-C classes from Python";
    homepage = "https://github.com/kivy/pyobjus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
    ];
    platforms = lib.platforms.darwin;
  };
})
