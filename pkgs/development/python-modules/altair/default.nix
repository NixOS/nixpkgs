{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, pytest, jinja2, sphinx, vega_datasets, ipython, glibcLocales
, entrypoints, jsonschema, numpy, pandas, six, toolz, typing
, pythonOlder, recommonmark }:

buildPythonPackage rec {
  pname = "altair";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63934563a7a7b7186335858206a0b9be6043163b8b54a26cd3b3299a9e5e391f";
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
