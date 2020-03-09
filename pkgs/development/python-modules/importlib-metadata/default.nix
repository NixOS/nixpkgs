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
, packaging
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "1.5.0";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    sha256 = "00ikdj4gjhankdljnz7g5ggak4k9lql2926x0x117ir9j2lv7x86";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ zipp ]
    ++ lib.optionals (!isPy3k) [ pathlib2 contextlib2 configparser ];

  checkInputs = [ importlib-resources packaging ];

  # removing test_main.py - it requires 'pyflakefs'
  # and adding `pyflakefs` to `checkInputs` causes infinite recursion.
  preCheck = ''
    rm importlib_metadata/tests/test_main.py
  '';

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = https://importlib-metadata.readthedocs.io/;
    license = licenses.asl20;
  };
}
