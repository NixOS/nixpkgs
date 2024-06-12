{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "rpmfile";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tLDdVTrZlxGk+oYmeCm/4XLAPx6hzkztJP+lXtiDhb4=";
  };

  # Tests access the internet
  doCheck = false;

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "rpmfile" ];

  meta = with lib; {
    description = "Read rpm archive files";
    mainProgram = "rpmfile";
    homepage = "https://github.com/srossross/rpmfile";
    license = licenses.mit;
    maintainers = [ ];
  };
}
