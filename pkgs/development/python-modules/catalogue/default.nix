{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "catalogue";
  version = "2.0.6";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "explosion";
     repo = "catalogue";
     rev = "v2.0.6";
     sha256 = "0024jqhmpwa86l0a2x5f61ycz465168p979kc32qwi27ayykwdbs";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "catalogue" ];

  meta = with lib; {
    description = "Tiny library for adding function or object registries";
    homepage = "https://github.com/explosion/catalogue";
    changelog = "https://github.com/explosion/catalogue/releases/tag/v${version}";
    license = licenses.mit;
  };
}
