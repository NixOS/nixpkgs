{ buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, lib
}:

buildPythonPackage rec {
  pname   = "prodict";
  version = "0.8.6";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ramazanpolat";
    repo = pname;
    rev = version;
    hash = "sha256-c46JEQFg4KRwerqpMSgh6+tYRpKTOX02Lzsq4/meS3o=";
  };

  # make setuptools happy on case-sensitive filesystems
  postPatch = ''if [[ ! -f README.md ]]; then mv README.MD README.md; fi'';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "prodict" ];

  meta = {
    description = "Access Python dictionary as a class with type hinting and autocompletion";
    homepage = "https://github.com/ramazanpolat/prodict";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
