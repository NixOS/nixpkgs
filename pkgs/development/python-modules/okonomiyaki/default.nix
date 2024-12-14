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
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "okonomiyaki";
    rev = "refs/tags/${version}";
    hash = "sha256-JQZhw0H4iSdxoyS6ODICJz1vAZsOISQitX7wTgSS1xc=";
  };

  postPatch = ''
    # Fixed for >= 2.0.0
    substituteInPlace setup.cfg \
      --replace-fail "long_description_content_type = rst" "long_description_content_type = text/x-rst"
  '';

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
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck =
    ''
      substituteInPlace okonomiyaki/runtimes/tests/test_runtime.py \
        --replace-fail 'runtime_info = PythonRuntime.from_running_python()' 'raise unittest.SkipTest() #'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace okonomiyaki/platforms/tests/test_pep425.py \
        --replace-fail 'self.assertEqual(platform_tag, self.tag.platform)' 'raise unittest.SkipTest()'
    '';

  pythonImportsCheck = [ "okonomiyaki" ];

  meta = with lib; {
    description = "Experimental library aimed at consolidating a lot of low-level code used for Enthought's eggs";
    homepage = "https://github.com/enthought/okonomiyaki";
    changelog = "https://github.com/enthought/okonomiyaki/releases/tag/${version}";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd3;
  };
}
