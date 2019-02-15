{ stdenv, buildPythonPackage, fetchPypi, fetchpatch
, pytest, jinja2, sphinx, vega_datasets, ipython
, entrypoints, jsonschema, numpy, pandas, six, toolz, typing
, pythonOlder, recommonmark }:

buildPythonPackage rec {
  pname = "altair";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f4bc7cd132c0005deb6b36c7041ee213a69bbdfcd8c0b1a9f1ae8c1fba733f6";
  };

  checkInputs = [ pytest jinja2 sphinx vega_datasets ipython  recommonmark ];

  propagatedBuildInputs = [ entrypoints jsonschema numpy pandas six toolz ]
    ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ];

  # hack to prevent typing from being required for python > 3.5
  postPatch = ''
    substituteInPlace requirements.txt \
       --replace "typing" ""
  '';

  checkPhase = ''
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
