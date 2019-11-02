{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.40";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42de6eaab4ed149e60c9b367ada54f01a3b1e4d6846784f9b9710e770ff5572c";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mgedmin/check-manifest;
    description = "Check MANIFEST.in in a Python source package for completeness";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
