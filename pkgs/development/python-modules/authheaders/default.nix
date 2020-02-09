{ buildPythonPackage, fetchPypi, isPy27, lib
, authres, dnspython, dkimpy, ipaddress, publicsuffix
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hf1p6ws3jma608pmcb5qsl58xg33wz2s51qqzi9zix0llcnyc97";
  };

  propagatedBuildInputs = [ authres dnspython dkimpy publicsuffix ]
                          ++ lib.optional isPy27 ipaddress;

  meta = {
    description = "Python library for the generation of email authentication headers";
    homepage = https://github.com/ValiMail/authentication-headers;
    license = lib.licenses.mit;
  };
}
