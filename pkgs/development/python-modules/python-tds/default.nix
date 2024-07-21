{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  pytestCheckHook,
  pyopenssl,
  pyspnego,
  namedlist,
  pydes,
  cryptography,
}:

buildPythonPackage rec {
  pname = "python-tds";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "denisenkom";
    repo = "pytds";
    rev = version;
    hash = "sha256-ubAXCifSfNtxbFIJZD8IuK/8oPT9vo77YBCexoO9zsw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version.get_git_version()" '"${version}"'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    pytestCheckHook
    pyopenssl
    pyspnego
    namedlist
    pydes
    cryptography
  ];

  disabledTests = [
    # ImportError: To use NTLM authentication you need to install ntlm-auth module
    # ntlm-auth has been removed from nixpkgs
    "test_ntlm"

    # TypeError: CertificateBuilder.add_extension() got an unexpected keyword argument 'extension'
    # Tests are broken for pyOpenSSL>=23.0.0
    # https://github.com/denisenkom/pytds/blob/1.13.0/test_requirements.txt
    "test_with_simple_server_req_encryption"
    "test_both_server_and_client_encryption_on"
    "test_server_has_enc_on_but_client_is_off"
    "test_only_login_encrypted"
    "test_server_encryption_not_supported"
    "test_server_with_bad_name_in_cert"
    "test_cert_with_san"
    "test_encrypted_socket"
  ];

  pythonImportsCheck = [ "pytds" ];

  meta = with lib; {
    description = "Python DBAPI driver for MSSQL using pure Python TDS (Tabular Data Stream) protocol implementation";
    homepage = "https://python-tds.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
