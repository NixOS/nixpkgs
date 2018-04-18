{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.36";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2bb906a736a0f026cc5fd6c0dab5a481793b3d7a7d70106cca6e238da5f52d84";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mgedmin/check-manifest;
    description = "Check MANIFEST.in in a Python source package for completeness";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
