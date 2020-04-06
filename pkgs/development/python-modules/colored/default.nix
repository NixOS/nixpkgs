{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "colored";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "056fac09d9e39b34296e7618897ed1b8c274f98423770c2980d829fd670955ed";
  };

  # No proper test suite
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/dslackw/colored;
    description = "Simple library for color and formatting to terminal";
    license = licenses.mit;
  };

}
