{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyasn1,
  pyopenssl,
}:

buildPythonPackage rec {
  version = "0.5.1";
  format = "setuptools";
  pname = "ndg-httpsclient";

  src = fetchFromGitHub {
    owner = "cedadev";
    repo = "ndg_httpsclient";
    rev = version;
    hash = "sha256-Pxdrq0H4w0yJ1huo24L8jFnM3dzglme1lr6Tqoh+GlI=";
  };

  propagatedBuildInputs = [
    pyasn1
    pyopenssl
  ];

  # uses networking
  doCheck = false;

  meta = {
    homepage = "https://github.com/cedadev/ndg_httpsclient/";
    description = "Provide enhanced HTTPS support for httplib and urllib2 using PyOpenSSL";
    mainProgram = "ndg_httpclient";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
