{ stdenv, buildPythonPackage, fetchPypi
, pytest, jinja2, sphinx, vega_datasets, ipython, glibcLocales
, entrypoints, jsonschema, numpy, pandas, six, toolz, typing
, pythonOlder, recommonmark }:

buildPythonPackage rec {
  pname = "altair";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zdznkybw3g8fd280h5j5cnnwcv30610gp8fl8vwqda1w2p6pgvp";
  };

  postPatch = ''
    # Tests require network
    rm altair/examples/boxplot_max_min.py altair/examples/line_percent.py
  '';

  checkInputs = [ pytest jinja2 sphinx vega_datasets ipython glibcLocales recommonmark ];

  propagatedBuildInputs = [ entrypoints jsonschema numpy pandas six toolz ]
    ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ];

  checkPhase = ''
    export LANG=en_US.UTF-8
    py.test altair --doctest-modules
  '';

  meta = with stdenv.lib; {
    description = "A declarative statistical visualization library for Python.";
    homepage = https://github.com/altair-viz/altair;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.unix;
  };
}
