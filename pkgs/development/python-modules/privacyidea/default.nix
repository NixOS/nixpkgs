{ lib, buildPythonPackage, fetchFromGitHub, cacert, openssl, python, nixosTests

, cryptography, pyrad, pymysql, python-dateutil, flask-versioned, flask_script
, defusedxml, croniter, flask_migrate, pyjwt, configobj, sqlsoup, pillow
, python-gnupg, passlib, pyopenssl, beautifulsoup4, smpplib, flask-babel
, ldap3, huey, pyyaml, qrcode, oauth2client, requests, lxml, cbor2, psycopg2
, pydash

, mock, pytestCheckHook, responses, testfixtures
}:

buildPythonPackage rec {
  pname = "privacyIDEA";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-k2om2LjkFRCT53ECPAJEztCiMdz4fF5eoipVUvSoyGo=";
    fetchSubmodules = true;
  };

  patches = [
    # Subset of https://github.com/privacyidea/privacyidea/commit/359db6dd10212b8a210e0a83536e92e9e796a1f8,
    # fixes app context errors in tests. Can be removed on the next bump.
    ./fix-tests.patch
  ];

  propagatedBuildInputs = [
    cryptography pyrad pymysql python-dateutil flask-versioned flask_script
    defusedxml croniter flask_migrate pyjwt configobj sqlsoup pillow
    python-gnupg passlib pyopenssl beautifulsoup4 smpplib flask-babel
    ldap3 huey pyyaml qrcode oauth2client requests lxml cbor2 psycopg2
    pydash
  ];

  passthru.tests = { inherit (nixosTests) privacyidea; };

  checkInputs = [ openssl mock pytestCheckHook responses testfixtures ];
  disabledTests = [
    "AESHardwareSecurityModuleTestCase"
    "test_01_cert_request"
    "test_01_loading_scripts"
    "test_02_api_push_poll"
    "test_02_cert_enrolled"
    "test_02_enroll_rights"
    "test_02_get_resolvers"
    "test_02_success"
    "test_03_get_identifiers"
    "test_04_remote_user_auth"
    "test_14_convert_timestamp_to_utc"
  ];

  pythonImportsCheck = [ "privacyidea" ];

  postPatch = ''
    substituteInPlace privacyidea/lib/resolvers/LDAPIdResolver.py --replace \
      "/etc/privacyidea/ldap-ca.crt" \
      "${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  postInstall = ''
    rm -rf $out/${python.sitePackages}/tests
  '';

  meta = with lib; {
    description = "Multi factor authentication system (2FA, MFA, OTP Server)";
    license = licenses.agpl3Plus;
    homepage = "http://www.privacyidea.org";
    maintainers = with maintainers; [ globin ma27 ];
  };
}
