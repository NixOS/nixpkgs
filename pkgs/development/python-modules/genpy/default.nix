{ lib
, buildPythonPackage
, fetchFromGitHub
, pytools
, numpy
}:

buildPythonPackage rec {
  pname = "genpy";
  version = "2021.1";

  src = fetchFromGitHub {
     owner = "inducer";
     repo = "genpy";
     rev = "v2021.1";
     sha256 = "0vjmgzjzbd5kz0rwccdlkp3magrwyinvb4dbvhkdp8nxnp1jcaar";
  };

  propagatedBuildInputs = [
    pytools
    numpy
  ];

  meta = with lib; {
    description = "C/C++ source generation from an AST";
    homepage = "https://github.com/inducer/genpy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
