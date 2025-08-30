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
  pythonOlder,
  pyyaml,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "omegaconf";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omry";
    repo = "omegaconf";
    tag = "v${version}";
    hash = "sha256-Qxa4uIiX5TAyQ5rFkizdev60S4iVAJ08ES6FpNqf8zI=";
  };

  patches = [
    (replaceVars ./antlr4.patch {
      antlr_jar = "${antlr4.out}/share/java/antlr-${antlr4.version}-complete.jar";
    })

    # https://github.com/omry/omegaconf/pull/1137
    ./0000-add-support-for-dataclasses_missing_type.patch
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

  meta = with lib; {
    description = "Framework for configuring complex applications";
    homepage = "https://github.com/omry/omegaconf";
    changelog = "https://github.com/omry/omegaconf/blob/v${version}/NEWS.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
