{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
, toml
, zipp
}:

buildPythonPackage rec {
  pname = "importlib-metadata";
  version = "3.7.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "importlib_metadata";
    inherit version;
    sha256 = "1pmci5r6hgl3vj558mawclfq2d4aq584nsjvc1fqvyb921hgzm8q";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ toml zipp ];

  # Cyclic dependencies due to pyflakefs
  doCheck = false;
  pythonImportsCheck = [ "importlib_metadata" ];

  meta = with lib; {
    description = "Read metadata from Python packages";
    homepage = "https://importlib-metadata.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
