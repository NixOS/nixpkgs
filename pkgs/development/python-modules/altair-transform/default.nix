{ buildPythonPackage
, fetchPypi
, ply
, altair
, numpy
, pandas
, dataclasses
, pytest
, jinja2
, lib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "altair_transform";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rid432fqslaaqjnpd4fm5hxq88160w5yqr6qsm4n9bi795cjj5k";
  };

  propagatedBuildInputs = [
    ply
    altair
    numpy
    pandas
  ] ++ lib.optionals (pythonOlder "3.7") [ dataclasses ];

  checkInputs = [
    jinja2
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = {
    homepage = "https://github.com/altair-viz/altair-transform";
    description = "Python evaluation of Altair/Vega-Lite transforms";
    license = lib.licenses.mit;
  };

}
