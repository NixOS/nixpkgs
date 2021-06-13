{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pypdt";
  version = "0.8.0";

  src = fetchPypi {
    pname = "PyPDT";
    inherit version;
    sha256 = "92dc26389e61f7527e9ca296e58e4d58f979b2fd0a9ce40e9eeccf356c60ac13";
  };

  doCheck = false; # no tests
  pythonImportsCheck = [ "pypdt" ];

  meta = with lib; {
    description = "Python package for high-energy and nuclear physics Particle Data Table and Particle ID code interpretation";
    homepage = "https://gitlab.com/hepcedar/pypdt";
    license = licenses.unfree;
    maintainers = with maintainers; [ veprbl ];
  };
}
