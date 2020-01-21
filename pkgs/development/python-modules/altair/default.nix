{ stdenv, buildPythonPackage, fetchPypi, isPy27
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
  version = "4.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "92dcd7b84c715f8e02bbdf37e36193a4af8138b5b064c05f237e6ed41573880a";
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
