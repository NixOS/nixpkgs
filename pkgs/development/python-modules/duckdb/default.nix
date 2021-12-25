{ lib
, buildPythonPackage
, duckdb
, mypy
, numpy
, pandas
, pybind11
, setuptools-scm
, pytest-runner
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "duckdb";
  inherit (duckdb) version src;

  # build attempts to use git to figure out its own version. don't want to add
  # the dependency for something pointless.
  postPatch = ''
    substituteInPlace scripts/package_build.py --replace \
      "'git'" "'false'"
  '';

  postConfigure = ''
    cd tools/pythonpkg
    export SETUPTOOLS_SCM_PRETEND_VERSION=${version}
  '';

  nativeBuildInputs = [
    pybind11
    setuptools-scm
    pytest-runner
  ];

  propagatedBuildInputs = [
    numpy
    pandas
  ];

  checkInputs = [
    pytestCheckHook
    mypy
  ];

  pythonImportsCheck = [ "duckdb" ];

  meta = with lib; {
    description = "Python binding for DuckDB";
    homepage = "https://duckdb.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
