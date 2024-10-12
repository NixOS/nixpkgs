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
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "omegaconf";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omry";
    repo = "omegaconf";
    rev = "refs/tags/v${version}";
    hash = "sha256-Qxa4uIiX5TAyQ5rFkizdev60S4iVAJ08ES6FpNqf8zI=";
  };

  patches = [
    (substituteAll {
      src = ./antlr4.patch;
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
    pytestCheckHook
  ];

  pythonImportsCheck = [ "omegaconf" ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTests = [ "test_eq" ];

  meta = with lib; {
    description = "Framework for configuring complex applications";
    homepage = "https://github.com/omry/omegaconf";
    changelog = "https://github.com/omry/omegaconf/blob/v${version}/NEWS.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
