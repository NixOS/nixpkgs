{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
}:

buildPythonPackage rec {
  version = "0.4.2";
  pname = "ndg-httpsclient";

  propagatedBuildInputs = [ pyopenssl ];

  src = fetchFromGitHub {
    owner = "cedadev";
    repo = "ndg_httpsclient";
    rev = version;
    sha256 = "1kk4knv029j0cicfiv23c1rayc1n3f1j3rhl0527gxiv0qv4jw8h";
  };

  # uses networking
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/cedadev/ndg_httpsclient/;
    description = "Provide enhanced HTTPS support for httplib and urllib2 using PyOpenSSL";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };

}
