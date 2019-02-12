{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ce160db245375a5ccf0831be77cd98394f514c1b3501ddff5f8edb780ee1748";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Pairwise test combinations generator";
    homepage = https://github.com/thombashi/allpairspy;
    license = licenses.mit;
  };
}
