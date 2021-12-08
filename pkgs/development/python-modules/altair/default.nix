{ lib, buildPythonPackage, fetchFromGitHub, isPy27
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
  version = "4.1.0";
  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "altair-viz";
     repo = "altair";
     rev = "v4.1.0";
     sha256 = "0da0ry4qdwwz40rw4rwx77y5jks9bq9s7l96jc55g0v13nwc1ar9";
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
