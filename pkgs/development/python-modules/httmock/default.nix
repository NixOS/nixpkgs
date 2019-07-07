{ stdenv, buildPythonPackage, fetchFromGitHub, requests }:

buildPythonPackage rec {
  pname   = "httmock";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "patrys";
    repo = "httmock";
    rev = version;
    sha256 = "1dy7pjq4gz476jcnbbpzk8w8qxr9l8wwgw9x2c7lf6fzsgnf404q";
  };

  checkInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "A mocking library for requests";
    homepage    = https://github.com/patrys/httmock;
    license     = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
