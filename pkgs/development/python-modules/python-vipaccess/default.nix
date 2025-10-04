{
  lib,
  buildPythonPackage,
  fetchPypi,
  oath,
  pycryptodome,
  requests,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-vipaccess";
  version = "0.14.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TFSX8iL6ChaL3Fj+0VCHzafF/314Y/i0aTI809Qk5hU=";
  };

  propagatedBuildInputs = [
    oath
    pycryptodome
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  # test_check_token_detects_valid_hotp_token,
  # test_check_token_detects_valid_totp_token and
  # test_check_token_detects_invlaid_token require network

  # unittest based tests using yield, imcompatible with pytest
  preCheck = ''
    mv vipaccess vipaccess.hidden
    substituteInPlace tests/test_utils.py \
      --replace-fail "test_check_TOTP_token_models" "check_TOTP_token_models" \
      --replace-fail "test_check_HOTP_token_models" "check_HOTP_token_models"
  '';

  disabledTests = [
    "test_check_token_detects_invalid_token"
  ];

  meta = with lib; {
    description = "Free software implementation of Symantec's VIP Access application and protocol";
    mainProgram = "vipaccess";
    homepage = "https://github.com/dlenski/python-vipaccess";
    license = licenses.asl20;
    maintainers = with maintainers; [ aw ];
  };
}
