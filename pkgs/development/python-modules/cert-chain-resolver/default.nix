{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pytest-mock
, cryptography
}:

buildPythonPackage rec {
  pname = "cert-chain-resolver";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "rkoopmans";
    repo = "python-certificate-chain-resolver";
    rev = version;
    sha256 = "1kmig4ksbx1wvgcjn4r9jjg2pn1ag5rq871bjwxkp9kslb3x3d1l";
  };

  propagatedBuildInputs = [ cryptography ];

  checkInputs = [ pytestCheckHook pytest-mock ];

  # online tests
  disabledTests = [
    "test_cert_returns_completed_chain"
    "test_display_flag_is_properly_formatted"
  ];

  meta = with lib; {
    homepage = "https://github.com/rkoopmans/python-certificate-chain-resolver";
    description = "Resolve / obtain the certificate intermediates of a x509 certificate";
    license = licenses.mit;
    maintainers = with maintainers; [ veehaitch ];
  };
}
