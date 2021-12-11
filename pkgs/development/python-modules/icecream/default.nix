{ lib, buildPythonPackage, fetchFromGitHub
, asttokens, colorama, executing, pygments
}:

buildPythonPackage rec {
  pname = "icecream";
  version = "2.1.1";

  src = fetchFromGitHub {
     owner = "gruns";
     repo = "icecream";
     rev = "v2.1.1";
     sha256 = "1mj7cjvydksmv60n2zkrr7a7ci2vcck3x9w0mifcah1cs4cdcc6d";
  };

  propagatedBuildInputs = [ asttokens colorama executing pygments ];

  meta = with lib; {
    description = "A little library for sweet and creamy print debugging";
    homepage = "https://github.com/gruns/icecream";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
