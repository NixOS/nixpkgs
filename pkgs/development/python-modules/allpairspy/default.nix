{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9p0xo7Vu7hGdHsYGPpxzLdRPu6NS73OMsi2WmfxACf4=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Pairwise test combinations generator";
    homepage = "https://github.com/thombashi/allpairspy";
    license = licenses.mit;
  };
}
