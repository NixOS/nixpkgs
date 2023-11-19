{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, yasm
}:

buildPythonPackage rec {
  pname = "distorm3";
  version = "3.5.2";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "gdabah";
    repo = "distorm";
    rev = version;
    sha256 = "012bh1l2w7i9q8rcnznj3x0lra09d5yxd3r42cbrqdwl1mmg26qn";
  };

  nativeCheckInputs = [
    pytestCheckHook
    yasm
  ];

  disabledTests = [
    # TypeError: __init__() missing 3 required positional...
    "test_dummy"
  ];

  pythonImportsCheck = [ "distorm3" ];

  meta = with lib; {
    description = "Disassembler library for x86/AMD64";
    homepage = "https://github.com/gdabah/distorm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
