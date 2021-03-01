{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, toml
, pep517
, packaging
, isPy3k
, typing
, pythonOlder
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "build";
  version = "0.1.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d6m21lijwm04g50nwgsgj7x3vhblzw7jv05ah8psqgzk20bbch8";
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

  # No tests in archive
  doCheck = false;

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
