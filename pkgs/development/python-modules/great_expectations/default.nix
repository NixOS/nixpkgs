{ lib
, python
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, click
, pandas
, termcolor
, colorama
, tzlocal
, jsonschema
, ipywidgets
, typing-extensions
, ruamel-yaml
, jsonpatch
, cryptography
, altair
, tqdm
, jinja2
, importlib-metadata
, pyparsing
, scipy
, nbformat
, notebook
, ipython
, mistune
, numpy
, packaging
, python-dateutil
, pytz
, requests
, urllib3
, pytest  # Test dependencies
, pytest-benchmark
, sqlalchemy
, pyspark
, freezegun
, boto3
, moto
, requirements-parser
, glibcLocales
, black
, isort
, pyfakefs
, snapshottest
, nbconvert
, flake8
, pre-commit
, pytest-cov
, pytest-order
, pyupgrade
, pyarrow
}:

buildPythonPackage rec {
  pname = "great_expectations";
  version = "0.15.3";
  # assets directory uset in tests not included in PyPi files
  # so tests only pass when using github as src
  src = fetchFromGitHub {
    owner = "great-expectations";
    repo = "great_expectations";
    rev = version;
    sha256 = "sha256-6WU/PKR32OlzxjqqOl71q9AHyBtAEUJMIz3SCDt0stI=";
  };
  propagatedBuildInputs = [
    altair
    click
    colorama
    cryptography
    importlib-metadata
    ipython
    jinja2
    jsonpatch
    jsonschema
    mistune
    nbformat
    notebook
    numpy
    packaging
    pandas
    pyparsing
    python-dateutil
    pytz
    requests
    ruamel-yaml
    scipy
    termcolor
    tqdm
    typing-extensions
    tzlocal
    urllib3
  ];

  checkInputs = [
    pytest
    pytest-benchmark
    sqlalchemy
    pyspark
    freezegun
    boto3
    moto
    requirements-parser
    black
    glibcLocales
    isort
    ipywidgets
    pyfakefs
    snapshottest
    nbconvert
    flake8
    pre-commit
    pytest-cov
    pytest-order
    pyupgrade
    pyarrow
  ];

  # Skipping some tests:
  # execution_engine/test_sqlalchemy_execution_engine_splitting.py requires mock-alchemy python library
  # cli/v012 fails, but v012 is old
  # integration/usage_statistics/* mostly require internet access
  checkPhase = ''
    export LC_ALL="en_US.UTF-8"
    runHook preCheck
    ${python.interpreter} -m pytest -x \
      --ignore ./tests/execution_engine/test_sqlalchemy_execution_engine_splitting.py \
      --ignore ./tests/cli/v012 \
      --ignore ./tests/integration/usage_statistics
    runHook postCheck
  '';

  patches = [
    ./relax_dependency_version_constraints.patch
    ./fix_jinja_contextfilter.patch # work around contextfilter renaming
  ];

  meta = with lib; {
    description = "Always know what to expect from your data";
    homepage = https://github.com/great-expectations/great_expectations;
    license = licenses.asl20;
    maintainers = with maintainers; [ harvidsen ];
  };
}
