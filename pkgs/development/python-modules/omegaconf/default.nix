{
  lib,
  antlr4,
  antlr4-python3-runtime,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jre_minimal,
  pydevd,
  pytest-mock,
  pytest7CheckHook,
  pythonAtLeast,
  pyyaml,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "omegaconf";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hydra-ecosystem";
    repo = "omegaconf";
    tag = "v${version}";
    hash = "sha256-HvK6bNInPIkfdpNh8DifH7Wxt8m9uR+Y/qL3voIUw6w=";
  };

  patches = [
    (replaceVars ./antlr4.patch {
      antlr_jar = "${antlr4.out}/share/java/antlr-${antlr4.version}-complete.jar";
    })
  ];

  postPatch = ''
    # We substitute the path to the jar with the one from our antlr4
    # package, so this file becomes unused
    rm -v build_helpers/bin/antlr*-complete.jar

    sed -i 's/antlr4-python3-runtime==.*/antlr4-python3-runtime/' requirements/base.txt
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ jre_minimal ];

  dependencies = [
    antlr4-python3-runtime
    pyyaml
  ];

  nativeCheckInputs = [
    attrs
    pydevd
    pytest-mock
    pytest7CheckHook
  ];

  pythonImportsCheck = [ "omegaconf" ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
    "-Wignore::UserWarning"
  ];

  disabledTests = [
    # assert (1560791320562868035 == 1560791320562868035) == False
    "test_eq"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # pathlib._local.Path != pathlib.Path type check mismatch
    "test_errors"
    "test_to_yaml"
    "test_type_str"
  ];

  meta = {
    description = "Framework for configuring complex applications";
    homepage = "https://github.com/hydra-ecosystem/omegaconf";
    changelog = "https://github.com/hydra-ecosystem/omegaconf/blob/v${version}/NEWS.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
