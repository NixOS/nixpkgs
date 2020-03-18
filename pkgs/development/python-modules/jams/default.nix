{ stdenv, buildPythonPackage, fetchPypi, pandas, sortedcontainers, jsonschema
, numpy, six, decorator, mir_eval, future }:

buildPythonPackage rec {
  pname = "jams";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8bb2158bd19b4f057b8b90321b44b1dd1659c66cbebe0d4219889d31d7f888b9";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/marl/jams";
    description =
      "A JSON Annotated Music Specification for Reproducible MIR Research";
    license = licenses.isc;
    maintainers = with maintainers; [ jmorag ];
  };

  propagatedBuildInputs =
    [ pandas sortedcontainers jsonschema numpy six decorator mir_eval future ];
  doCheck = false;
}
