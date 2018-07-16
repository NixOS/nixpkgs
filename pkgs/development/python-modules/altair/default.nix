{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, pytest, jinja2, sphinx, vega_datasets, ipython, glibcLocales
, entrypoints, jsonschema, numpy, pandas, six, toolz, typing }:

buildPythonPackage rec {
  pname = "altair";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8b222588dde98ec614e6808357fde7fa321118db44cc909df2bf30158d931c0";
  };

  patches = fetchpatch {
    url = https://github.com/altair-viz/altair/commit/bfca8aecce9593c48aa5834e3f8f841deb58391c.patch;
    sha256 = "01izc5d8c6ry3mh0k0hfasb6jc4720g75yw2qdlp9ja8mnjsp4k3";
  };

  checkInputs = [ pytest jinja2 sphinx vega_datasets ipython glibcLocales ];

  checkPhase = ''
    export LANG=en_US.UTF-8
    py.test altair --doctest-modules
  '';

  propagatedBuildInputs = [ entrypoints jsonschema numpy pandas six toolz typing ];

  meta = with stdenv.lib; {
    description = "A declarative statistical visualization library for Python.";
    homepage = https://github.com/altair-viz/altair;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.linux;
  };
}
