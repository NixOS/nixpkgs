{ stdenv, buildPythonPackage, fetchPypi, pytest, pep257 }:

buildPythonPackage rec {
  pname = "pytest-pep257";
  version = "0.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "082v3d5k4331x53za51kl8zxsndsw1pcyf1xdfpb2gjdjrhixb8w";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pep257 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/anderslime/pytest-pep257";
    description = "py.test plugin for PEP257";
    license = licenses.mit;
  };
}
