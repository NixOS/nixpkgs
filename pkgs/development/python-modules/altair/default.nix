{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, pytest, jinja2, sphinx, vega_datasets, ipython, glibcLocales
, entrypoints, jsonschema, numpy, pandas, six, toolz, typing
, pythonOlder, recommonmark }:

buildPythonPackage rec {
  pname = "altair";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lqln4510qqqla6s8z4ca0271qrhq6yyznsijsdn3nssvxsynqpc";
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
