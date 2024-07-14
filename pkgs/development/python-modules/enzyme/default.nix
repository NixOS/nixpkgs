{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "enzyme";
  version = "0.4.1";
  format = "setuptools";

  # Tests rely on files obtained over the network
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8hZ/qXwk0RA6lNS/TrIPAMp2w4o3SZghBJJTsgWcYrs=";
  };

  meta = with lib; {
    homepage = "https://github.com/Diaoul/enzyme";
    license = licenses.asl20;
    description = "Python video metadata parser";
  };
}
