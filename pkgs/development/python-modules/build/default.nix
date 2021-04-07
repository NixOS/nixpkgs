{ lib
, buildPythonPackage
, fetchPypi
, filelock
, flit-core
, importlib-metadata
, isPy3k
, packaging
, pep517
, pytest-mock
, pytest-xdist
, pytestCheckHook
, pythonOlder
, toml
, typing ? null
}:

buildPythonPackage rec {
  pname = "build";
  version = "0.3.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DrlbLI13DXxMm5LGjCJ8NQu/ZfPsg1UazpCXwYzBX90=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    toml
    pep517
    packaging
  ] ++ lib.optionals (!isPy3k) [
    typing
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    filelock
    pytestCheckHook
    pytest-mock
    pytest-xdist
  ];

  disabledTests = [
    "test_isolation"
    "test_isolated_environment_install"
    "test_default_pip_is_never_too_old"
    "test_build_isolated - StopIteration"
    "test_build_raises_build_exception"
    "test_build_raises_build_backend_exception"
    "test_projectbuilder.py"
    "test_projectbuilder.py"
  ];

  pythonImportsCheck = [ "build" ];

  meta = with lib; {
    description = "Simple, correct PEP517 package builder";
    longDescription = ''
      build will invoke the PEP 517 hooks to build a distribution package. It
      is a simple build tool and does not perform any dependency management.
    '';
    homepage = "https://github.com/pypa/build";
    maintainers = with maintainers; [ fab ];
    license = licenses.mit;
  };
}
