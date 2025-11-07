{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libcec,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pycec";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "konikvranik";
    repo = "pycec";
    tag = "v${version}";
    hash = "sha256-5KQyHjAvHWeHFqcFHFJxDOPwWuVcFAN2wVdz9a77dzU=";
  };

  propagatedBuildInputs = [ libcec ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycec" ];

  meta = with lib; {
    description = "Python modules to access HDMI CEC devices";
    mainProgram = "pycec";
    homepage = "https://github.com/konikvranik/pycec/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
