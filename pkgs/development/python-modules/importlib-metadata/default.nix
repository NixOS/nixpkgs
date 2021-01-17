{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, zipp
, pathlib2
, contextlib2
, configparser
, isPy3k
, importlib-resources
, typing-extensions
, packaging
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "3.4.0";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    sha256 = "13gkxz2567iw2df8fg0li7sssqkzs16jx54m9villhd7fx2alpgs";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ zipp typing-extensions ]
    ++ lib.optionals (!isPy3k) [ pathlib2 contextlib2 configparser ];

  doCheck = false; # Cyclic dependencies.

  # removing test_main.py - it requires 'pyflakefs'
  # and adding `pyflakefs` to `checkInputs` causes infinite recursion.
  preCheck = ''
    rm importlib_metadata/tests/test_main.py
  '';

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = licenses.asl20;
  };
}
