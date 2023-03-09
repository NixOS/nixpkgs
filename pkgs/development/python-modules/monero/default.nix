{ lib
, buildPythonPackage
, fetchFromGitHub
, pycryptodomex
, pysocks
, pynacl
, requests
, six
, varint
, pytestCheckHook
, pytest-cov
, responses
}:

buildPythonPackage rec {
  pname = "monero";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "monero-ecosystem";
    repo = "monero-python";
    rev = "v${version}";
    sha256 = "sha256-WIF3pFBOLgozYTrQHLzIRgSlT3dTZTe+7sF/dVjVdTo=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'pynacl~=1.4' 'pynacl>=1.4' \
      --replace 'ipaddress' ""
  '';

  pythonImportsCheck = [ "monero" ];

  propagatedBuildInputs = [
    pycryptodomex
    pynacl
    pysocks
    requests
    six
    varint
  ];

  nativeCheckInputs = [ pytestCheckHook pytest-cov responses ];

  meta = with lib; {
    description = "Comprehensive Python module for handling Monero";
    homepage = "https://github.com/monero-ecosystem/monero-python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ prusnak ];
  };
}
