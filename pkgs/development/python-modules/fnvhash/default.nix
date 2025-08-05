{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fnvhash";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "znerol";
    repo = "py-fnvhash";
    tag = "v${version}";
    sha256 = "sha256-vAflKSvi0PD5r1q6GCTt6a4vTCsdBIebecRCKbbBphE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fnvhash" ];

  meta = with lib; {
    description = "Python FNV hash implementation";
    homepage = "https://github.com/znerol/py-fnvhash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
