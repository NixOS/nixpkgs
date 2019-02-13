{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, pytest, jinja2, sphinx, vega_datasets, ipython, glibcLocales
, entrypoints, jsonschema, numpy, pandas, six, toolz, typing
, pythonOlder, recommonmark }:

buildPythonPackage rec {
  pname = "altair";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c158699026eb5a19f95c1ca742e2e82bc20c27013ef5785f10836283e2233f8a";
  };

  checkInputs = [ pytest jinja2 sphinx vega_datasets ipython glibcLocales recommonmark ];

  propagatedBuildInputs = [ entrypoints jsonschema numpy pandas six toolz ]
    ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ];

  # hack to prevent typing from being required for python > 3.5
  postPatch = ''
    substituteInPlace requirements.txt \
       --replace "typing" ""
  '';

  checkPhase = ''
    export LANG=en_US.UTF-8
    py.test altair --doctest-modules
  '';

  meta = with stdenv.lib; {
    description = "A declarative statistical visualization library for Python.";
    homepage = https://github.com/altair-viz/altair;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.linux;
  };
}
