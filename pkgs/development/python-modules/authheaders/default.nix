{ buildPythonPackage, fetchFromGitHub, isPy27, lib
, authres, dnspython, dkimpy, ipaddress, publicsuffix2
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.14.1";

  src = fetchFromGitHub {
     owner = "ValiMail";
     repo = "authentication-headers";
     rev = "0.14.1";
     sha256 = "0snm0afyc55k45hgw6w98336np83l66xl2jkiz0jjabyrihh7nzs";
  };

  propagatedBuildInputs = [ authres dnspython dkimpy publicsuffix2 ]
                          ++ lib.optional isPy27 ipaddress;

  meta = {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    license = lib.licenses.mit;
  };
}
