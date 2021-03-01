{ lib, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "limits";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0c3319f032c4bfad68438ed1325c0fac86dac64582c7c25cddc87a0b658fa20";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false; # ifilter

  meta = with lib; {
    description = "Rate limiting utilities";
    license = licenses.mit;
    homepage = "https://limits.readthedocs.org/";
  };
}
