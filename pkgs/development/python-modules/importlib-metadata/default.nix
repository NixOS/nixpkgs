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
  version = "0.18";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    sha256 = "cb6ee23b46173539939964df59d3d72c3e0c1b5d54b84f1d8a7e912fe43612db";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ zipp ]
    ++ lib.optionals (!isPy3k) [ pathlib2 contextlib2 configparser ];

  checkInputs = [ importlib-resources packaging ];

  # Two failing tests: https://gitlab.com/python-devs/importlib_metadata/issues/72
  doCheck = false;

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = https://importlib-metadata.readthedocs.io/;
    license = licenses.asl20;
  };
}
