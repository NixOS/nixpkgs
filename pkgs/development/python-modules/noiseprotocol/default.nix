{ lib, buildPythonPackage, fetchFromGitHub, cryptography, pytestCheckHook }:

buildPythonPackage rec {
  pname = "noiseprotocol";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "plizonczyk";
    repo = "noiseprotocol";
    rev = "v${version}";
    sha256 = "1mk0rqpjifdv3v1cjwkdnjbrfmzzjm9f3qqs1r8vii4j2wvhm6am";
  };

  propagatedBuildInputs = [ cryptography ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "noise" ];

  meta = with lib; {
    description = "Noise Protocol Framework";
    homepage = "https://github.com/plizonczyk/noiseprotocol/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
