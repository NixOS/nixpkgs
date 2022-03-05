{ lib, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "limits";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da6346f0dcf85f17f0f1cc709c3408a3058cf6fee68313c288127c287237b411";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false; # ifilter

  meta = with lib; {
    description = "Rate limiting utilities";
    license = licenses.mit;
    homepage = "https://limits.readthedocs.org/";
  };
}
