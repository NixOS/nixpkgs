{ lib
, buildPythonPackage
, fetchFromGitHub
, pyasn1
, pyopenssl
}:

buildPythonPackage rec {
  version = "0.5.1";
  pname = "ndg-httpsclient";

  src = fetchFromGitHub {
    owner = "cedadev";
    repo = "ndg_httpsclient";
    rev = version;
    sha256 = "0lhsgs4am4xyjssng5p0vkfwqncczj1dpa0vss4lrhzq86mnn5rz";
  };


  propagatedBuildInputs = [
    pyasn1
    pyopenssl
  ];

  # uses networking
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/cedadev/ndg_httpsclient/";
    description = "Provide enhanced HTTPS support for httplib and urllib2 using PyOpenSSL";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };

}
