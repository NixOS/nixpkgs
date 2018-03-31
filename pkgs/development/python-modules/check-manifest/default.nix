{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0005vp3r7wh87pf41cr4rw015lbnzn228a607nx34r98p7cd17xi";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/mgedmin/check-manifest;
    description = "Check MANIFEST.in in a Python source package for completeness";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
