{ lib, buildPythonPackage, fetchPypi
, docutils, pygments, setuptools
}:

buildPythonPackage rec {
  pname = "pyroma";
  version = "3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45ad8201da9a813b5597bb85c80bbece93af9ec89170fc2be5ad85fa9463cef1";
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
