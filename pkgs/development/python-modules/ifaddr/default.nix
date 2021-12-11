{ lib
, buildPythonPackage
, fetchFromGitHub
, ipaddress
, python
}:

buildPythonPackage rec {
  version = "0.1.7";
  pname = "ifaddr";

  src = fetchFromGitHub {
     owner = "pydron";
     repo = "ifaddr";
     rev = "0.1.7";
     sha256 = "1wj8hq62f6fr9j7hdxkfylh4iw588x9yp9r5fj58k1imkw7lvb3s";
  };

  propagatedBuildInputs = [ ipaddress ];

  checkPhase = ''
   ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    homepage = "https://github.com/pydron/ifaddr";
    description = "Enumerates all IP addresses on all network adapters of the system";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
