{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "colored";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r1vsypk8v7az82d66bidbxlndx1h7xd4m43hpg1a6hsjr30wrm3";
  };

  # No proper test suite
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/dslackw/colored;
    description = "Simple library for color and formatting to terminal";
    license = licenses.mit;
  };

}
