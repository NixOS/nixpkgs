{ lib
, buildPythonPackage
, duckdb
, numpy
, pandas
, pybind11
, setuptools_scm
, pytestrunner
, pytest
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
    setuptools_scm
    pytestrunner
  ];

  checkInputs = [
    pytest
  ];

  requiredPythonModules = [
    numpy
    pandas
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "DuckDB is an embeddable SQL OLAP Database Management System";
    homepage = "https://pypi.python.org/pypi/duckdb";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
