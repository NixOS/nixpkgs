{ lib, buildPythonPackage, fetchFromGitHub, cacert, openssl, python

, cryptography, pyrad, pymysql, python-dateutil, flask-versioned, flask_script
, defusedxml, croniter, flask_migrate, pyjwt, configobj, sqlsoup, pillow
, python-gnupg, passlib, pyopenssl, beautifulsoup4, smpplib, flask-babel
, ldap3, huey, pyyaml, qrcode, oauth2client, requests, lxml, cbor2, psycopg2

, mock, pytest, responses, testfixtures
}:

buildPythonPackage rec {
  pname = "privacyIDEA";
  version = "3.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "188ki924dig899wlih45xfsm0s7mjkya56vii26bg02h91izrb4b";
  };

  propagatedBuildInputs = [
    cryptography pyrad pymysql python-dateutil flask-versioned flask_script
    defusedxml croniter flask_migrate pyjwt configobj sqlsoup pillow
    python-gnupg passlib pyopenssl beautifulsoup4 smpplib flask-babel
    ldap3 huey pyyaml qrcode oauth2client requests lxml cbor2 psycopg2
  ];

  checkInputs = [ openssl mock pytest responses testfixtures ];
  # issues with hardware token tests
  doCheck = false;

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
    maintainers = [ maintainers.globin ];
  };
}
