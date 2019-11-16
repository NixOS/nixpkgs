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
  version = "0.23";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    sha256 = "09mdqdfv5rdrwz80jh9m379gxmvk2vhjfz0fg53hid00icvxf65a";
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
