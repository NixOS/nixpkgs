{ lib, fetchFromGitHub, buildPythonPackage }:

buildPythonPackage rec {
  pname = "enzyme";
  version = "0.4.1";

  # Tests rely on files obtained over the network
  doCheck = false;

  src = fetchFromGitHub {
     owner = "Diaoul";
     repo = "enzyme";
     rev = "0.4.1";
     sha256 = "1xcsc05c7jgph133mg19fl3mnc7q43vrlq58pkzsbybgxv8v813q";
  };

  meta = with lib; {
    homepage = "https://github.com/Diaoul/enzyme";
    license = licenses.asl20;
    description = "Python video metadata parser";
  };
}
