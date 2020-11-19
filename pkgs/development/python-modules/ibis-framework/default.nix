{ lib, buildPythonPackage, fetchPypi, fetchpatch, isPy27, pythonAtLeast
, graphviz
, multipledispatch
, numpy
, pandas
, pyarrow
, pytest
, pytz
, regex
, requests
, sqlalchemy
, tables
, toolz
}:

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "1.3.0";
  disabled = isPy27 || pythonAtLeast "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1my94a11jzg1hv6ln8wxklbqrg6z5l2l77vr89aq0829yyxacmv7";
  };

  patches = [
    # fix tests for pandas 1.1
    (fetchpatch {
      url = "https://github.com/ibis-project/ibis/commit/53ef3cefc4ae90d61f3612310cb36da2bcd11305.diff";
      sha256 = "1i5yjmqridjqpggiinsjaz5spcxca5bd48vy7a0mj4mm1b5flw2m";
    })
  ];

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

  # ignore tests which require test dataset, or frameworks not available
  checkPhase = ''
    pytest ibis \
      --ignore=ibis/tests/all \
      --ignore=ibis/{sql,spark}
  '';

  meta = with lib; {
    description = "Productivity-centric Python Big Data Framework";
    homepage = "https://github.com/ibis-project/ibis";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
