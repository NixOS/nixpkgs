{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "breathe";
  version = "4.35.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "breathe-doc";
    repo = "breathe";
    rev = "refs/tags/v${version}";
    hash = "sha256-LJXvtScyWRL8zfj877bJ4xuIbLV9IN3Sn9KPUTLMjMI=";
  };

  patches = [
    # sphinx 7.2 support https://github.com/breathe-doc/breathe/pull/964
    (fetchpatch {
      url = "https://github.com/breathe-doc/breathe/commit/caa8dc45222b35d360c24bf36835a7d8e6d86df2.patch";
      hash = "sha256-wWe4x4WwZTrDhNZAF7mhfHHNEjd+Kp4YXghL+DPa10w=";
    })
    # sphinx 7.2 support https://github.com/breathe-doc/breathe/pull/976
    (fetchpatch {
      url = "https://github.com/breathe-doc/breathe/commit/09c856bf72de41e82582f31855e916295ba6d382.patch";
      hash = "sha256-vU3DUrj4Jj4AUolFFtWmaLMf9RG7TmKqJe5sCwwRjPI=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [
    defusedxml
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests fail with sphinx 7.4.x
    "tests/test_renderer.py"
  ];

  pythonImportsCheck = [ "breathe" ];

  meta = {
    description = "Sphinx Doxygen renderer";
    mainProgram = "breathe-apidoc";
    homepage = "https://github.com/breathe-doc/breathe";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.sphinx.members;
  };
}
