{ lib
, buildPythonPackage
, fetchPypi
, pathlib2
, contextlib2
, isPy3k
, importlib-resources
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "0.6";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    sha256 = "36b02c84f9001adf65209fefdf951be8e9014a95eab9938c0779ad5670359b1c";
  };

  propagatedBuildInputs = [] ++ lib.optionals (!isPy3k) [ pathlib2 contextlib2 ];

  checkInputs = [ importlib-resources ];

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = https://importlib-metadata.readthedocs.io/;
    license = licenses.asl20;
  };
}