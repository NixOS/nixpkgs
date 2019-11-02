{ stdenv, buildPythonPackage, fetchPypi
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
, typing
, vega_datasets
}:

buildPythonPackage rec {
  pname = "altair";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "098macm0sw54xqijdy1c8cppcgw79wn52qdc71qqb51nibc17gls";
  };

  propagatedBuildInputs = [
    entrypoints
    jsonschema
    numpy
    pandas
    six
    toolz
  ] ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ];

  checkInputs = [
    glibcLocales
    ipython
    jinja2
    pytest
    recommonmark
    sphinx
    vega_datasets
  ];

  checkPhase = ''
    export LANG=en_US.UTF-8
    pytest --doctest-modules altair
  '';

  meta = with stdenv.lib; {
    description = "A declarative statistical visualization library for Python.";
    homepage = https://github.com/altair-viz/altair;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.unix;
  };
}
