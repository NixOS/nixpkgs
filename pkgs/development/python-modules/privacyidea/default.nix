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
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XJnrrpU0x2Axu7W4G3oDTjSJuqEyh3C/0Aga5D0gw9k=";
    fetchSubmodules = true;
  };

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
