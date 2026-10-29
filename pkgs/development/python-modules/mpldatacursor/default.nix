{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "mpldatacursor";
  version = "0.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "joferkington";
    repo = "mpldatacursor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qmXjnZmM1iLt/Zdjd22lJaGySUQjMM07wfJB0w3lNEQ=";
  };

  propagatedBuildInputs = [ matplotlib ];

  # No tests included in archive
  doCheck = false;

  pythonImportsCheck = [ "mpldatacursor" ];

  meta = {
    homepage = "https://github.com/joferkington/mpldatacursor";
    description = "Interactive data cursors for matplotlib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bzizou ];
  };
})
