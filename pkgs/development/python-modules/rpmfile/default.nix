{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "rpmfile";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CsK7qJJ3xxhcuGHJxtfQyaJovlFpUW28amjxVWqeP5k=";
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
