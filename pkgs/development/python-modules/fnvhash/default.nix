{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fnvhash";
  version = "0.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "znerol";
    repo = "py-fnvhash";
    rev = "v${version}";
    sha256 = "00h8i70qd3dpsyf2dp7fkcb9m2prd6m3l33qv3wf6idpnqgjz6fq";
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
