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
  version = "1.3.0";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    sha256 = "0ibvvqajphwdclbr236gikvyja0ynvqjlix38kvsabgrf0jqafh7";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ zipp ]
    ++ lib.optionals (!isPy3k) [ pathlib2 contextlib2 configparser ];

  checkInputs = [ importlib-resources packaging ];

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = https://importlib-metadata.readthedocs.io/;
    license = licenses.asl20;
  };
}
