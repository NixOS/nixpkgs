{ stdenv, buildPythonPackage, fetchPypi
, numpy, pandas }:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "gtfparse";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f27aa2b87eb43d613edabf27f9c11147dc595c8683b440ac1d88e9acdb85873";
  };

  checkInputs = [ ];
  propagatedBuildInputs = [ numpy pandas];

  checkPhase = ''
  '';

  # Tests require extra dependencies
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/openvax/gtfparse";
    description = " Parsing tools for GTF (gene transfer format) files ";
    license = licenses.asl20;
  };
}
