{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pyannotate
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-annotate";
  version = "1.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0da4c3d872a7d5796ac85016caa1da38ae902bebdc759e1b6c0f6f8b5802741";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pyannotate
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pytest_annotate"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Generate PyAnnotate annotations from your pytest tests";
    homepage = "https://github.com/kensho-technologies/pytest-annotate";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
