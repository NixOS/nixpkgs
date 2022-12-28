{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, pint
}:

buildPythonPackage rec {
  pname = "fluids";
  version = "1.0.22";

  src = fetchFromGitHub {
      owner = "CalebBell";
      repo = "fluids";
      rev = "refs/tags/${version}";
      hash = "sha256-aMxnjFaWTnDCDnJrjlqInh/OH+EGxSCNIrHxE2MKIwU=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    pint
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/CalebBell/fluids";
    description = "Software for engineers and technicians working in the fields of chemical, mechanical, or civil engineering.";
    license = licenses.mit;
    maintainers = with maintainers; [ larsr ];
  };
}
