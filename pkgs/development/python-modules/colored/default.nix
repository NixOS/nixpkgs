{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "colored";
  version = "1.3.93";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xbhq9nd9xz3b6w0c4q33jfgnv8jid023v2fyhi7hsrz1scym5l2";
  };

  # No proper test suite
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/dslackw/colored;
    description = "Simple library for color and formatting to terminal";
    license = licenses.mit;
  };

}
