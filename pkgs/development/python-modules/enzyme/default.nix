{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "enzyme";
  version = "0.4.1";
  format = "setuptools";

  # Tests rely on files obtained over the network
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fv2kh2v4lwj0hhrhj9pib1pdjh01yr4xgyljhx11l94gjlpy5pj";
  };

  meta = with lib; {
    homepage = "https://github.com/Diaoul/enzyme";
    license = licenses.asl20;
    description = "Python video metadata parser";
  };
}
