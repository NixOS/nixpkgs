{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dill";
  version = "0.3.4";
  doCheck = !isPy27;

  src = fetchFromGitHub {
    owner = "uqfoundation";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0x702gh50wb3n820p2p9w49cn4a354y207pllwc7snfxprv6hypm";
  };

  checkInputs = [
    pytestCheckHook
  ];

  # Tests seem to fail because of import pathing and referencing items/classes in modules.
  # Seems to be a Nix/pathing related issue, not the codebase, so disabling failing tests.
  disabledTestPaths = [
    "tests/test_diff.py"
    "tests/test_module.py"
    "tests/test_objects.py"
  ];

  disabledTests = [
    "test_class_objects"
    "test_method_decorator"
    "test_importable"
    "test_the_rest"
  ];

  pythonImportsCheck = [ "dill" ];

  meta = with lib; {
    description = "Serialize all of python (almost)";
    homepage = "https://github.com/uqfoundation/dill/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
