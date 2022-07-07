{ lib, buildPythonPackage, fetchFromGitHub, cryptography, pytestCheckHook }:

buildPythonPackage rec {
  pname = "noiseprotocol";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "plizonczyk";
    repo = "noiseprotocol";
    rev = "v${version}";
    sha256 = "1mk0rqpjifdv3v1cjwkdnjbrfmzzjm9f3qqs1r8vii4j2wvhm6am";
  };

  propagatedBuildInputs = [ cryptography ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "noise" ];

  meta = with lib; {
    description = "Noise Protocol Framework";
    homepage = "https://github.com/plizonczyk/noiseprotocol/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
