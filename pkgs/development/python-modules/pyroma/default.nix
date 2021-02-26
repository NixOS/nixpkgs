{ lib, buildPythonPackage, fetchPypi
, docutils, pygments, setuptools
}:

buildPythonPackage rec {
  pname = "pyroma";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2527423e3a24ccd56951f3ce1b0ebbcc4fa0518c82fca882e696c78726ab9c2f";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pygments < 2.6" "pygments"
  '';

  propagatedBuildInputs = [ docutils pygments setuptools ];

  meta = with lib; {
    description = "Test your project's packaging friendliness";
    homepage = "https://github.com/regebro/pyroma";
    license = licenses.mit;
  };
}
