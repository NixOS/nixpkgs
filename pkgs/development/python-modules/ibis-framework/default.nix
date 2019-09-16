{ lib
, buildPythonPackage
, fetchPypi
, multipledispatch
, numpy
, pandas
, pytz
, regex
, toolz
, isPy27
, pytest
, sqlalchemy
, requests
, tables
, pyarrow
, graphviz
}:

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "1.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a0b79dae6924be0a79669c881a9a1d4817997ad2f81a0f3b1cd03d70aebb071";
  };

  propagatedBuildInputs = [
    multipledispatch
    numpy
    pandas
    pytz
    regex
    toolz
    sqlalchemy
    requests
    graphviz
    tables
    pyarrow
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest ibis
  '';

  meta = with lib; {
    description = "Productivity-centric Python Big Data Framework";
    homepage = https://github.com/ibis-project/ibis;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
