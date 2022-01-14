{ lib, buildPythonPackage, fetchPypi, isPy27
, entrypoints
, glibcLocales
, ipython
, jinja2
, jsonschema
, numpy
, pandas
, pytest
, pythonOlder
, recommonmark
, six
, sphinx
, toolz
, typing ? null
, vega_datasets
}:

buildPythonPackage rec {
  pname = "altair";
  version = "4.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d87d9372e63b48cd96b2a6415f0cf9457f50162ab79dc7a31cd7e024dd840026";
  };

  propagatedBuildInputs = [
    entrypoints
    jsonschema
    numpy
    pandas
    six
    toolz
    jinja2
  ] ++ lib.optionals (pythonOlder "3.5") [ typing ];

  checkInputs = [
    glibcLocales
    ipython
    pytest
    recommonmark
    sphinx
    vega_datasets
  ];

  pythonImportsCheck = [ "altair" ];

  checkPhase = ''
    export LANG=en_US.UTF-8
    # histogram_responsive.py attempt network access, and cannot be disabled through pytest flags
    rm altair/examples/histogram_responsive.py
    pytest --doctest-modules altair
  '';

  meta = with lib; {
    description = "A declarative statistical visualization library for Python.";
    homepage = "https://github.com/altair-viz/altair";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.unix;
  };
}
