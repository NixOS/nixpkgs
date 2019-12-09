{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "colored";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qf9470fsasimsmsri13jw1d2zpn3g24fv6vss64jq3ifwfkcs14";
  };

  # No proper test suite
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/dslackw/colored;
    description = "Simple library for color and formatting to terminal";
    license = licenses.mit;
  };

}
