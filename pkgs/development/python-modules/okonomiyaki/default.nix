{
  lib,
  stdenv,
  attrs,
  buildPythonPackage,
  distro,
  fetchFromGitHub,
  parameterized,
  jsonschema,
  mock,
  packaging,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  testfixtures,
  zipfile2,
}:

buildPythonPackage rec {
  pname = "okonomiyaki";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "okonomiyaki";
    tag = version;
    hash = "sha256-xAF9Tdr+IM3lU+mcNcAWATJLZOVvbx0llqznqHLVqDc=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    all = [
      attrs
      distro
      jsonschema
      zipfile2
    ];
    platforms = [
      attrs
      distro
    ];
    formats = [
      attrs
      distro
      jsonschema
      zipfile2
    ];
  };

  nativeCheckInputs = [
    packaging
    parameterized
    pytestCheckHook
    testfixtures
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  preCheck = ''
    substituteInPlace okonomiyaki/runtimes/tests/test_runtime.py \
      --replace-fail 'runtime_info = PythonRuntime.from_running_python()' 'raise unittest.SkipTest() #'
    substituteInPlace okonomiyaki/platforms/_platform.py \
      --replace-fail 'name.split()[0]' '(name.split() or [""])[0]'
  '';

  pythonImportsCheck = [ "okonomiyaki" ];

<<<<<<< HEAD
  meta = {
    description = "Experimental library aimed at consolidating a lot of low-level code used for Enthought's eggs";
    homepage = "https://github.com/enthought/okonomiyaki";
    changelog = "https://github.com/enthought/okonomiyaki/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ genericnerdyusername ];
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Experimental library aimed at consolidating a lot of low-level code used for Enthought's eggs";
    homepage = "https://github.com/enthought/okonomiyaki";
    changelog = "https://github.com/enthought/okonomiyaki/releases/tag/${src.tag}";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
