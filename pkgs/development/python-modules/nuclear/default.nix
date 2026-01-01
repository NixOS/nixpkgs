{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  colorama,
  mock,
  pyyaml,
  pydantic,
  backoff,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nuclear";
<<<<<<< HEAD
  version = "2.7.0";
=======
  version = "2.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "igrek51";
    repo = "nuclear";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-xKsYS+v/7xm9LRdpFKMsbrPggw4VfVMWst/3olj2n3E=";
=======
    hash = "sha256-6ZuRFZLhOqS9whkD0WtWD1/xSLhE8czDA3Za7Vcn1Mc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];
  dependencies = [
    colorama
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pydantic
    backoff
  ];
  disabledTestPaths = [
    # Disabled because test tries to install bash in a non-NixOS way
    "tests/autocomplete/test_bash_install.py"
  ];
  pythonImportsCheck = [ "nuclear" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://igrek51.github.io/nuclear/";
    description = "Binding glue for CLI Python applications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ parras ];
=======
  meta = with lib; {
    homepage = "https://igrek51.github.io/nuclear/";
    description = "Binding glue for CLI Python applications";
    license = licenses.mit;
    maintainers = with maintainers; [ parras ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
