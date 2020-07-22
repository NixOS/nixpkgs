{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "lazr.uri";
  version = "1.0.4";

  disabled = isPy27; # namespace is broken for python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "1griz2r0vhi9k91wfhlx5cx7y3slkfyzyqldaa9i0zp850iqz0q2";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "A self-contained, easily reusable library for parsing, manipulating";
    homepage = "https://launchpad.net/lazr.uri";
    license = licenses.lgpl3;
    maintainers = [ maintainers.marsam ];
  };
}
