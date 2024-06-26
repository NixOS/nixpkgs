{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "checksumdir";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "to-mc";
    repo = "checksumdir";
    rev = version;
    hash = "sha256-PO8sRGFQ1Dt/UYJuFH6Y3EaQVaS+4DJlOQtvF8ZmBWQ=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = false; # Package does not contain tests
  pythonImportsCheck = [ "checksumdir" ];

  meta = with lib; {
    description = "Simple package to compute a single deterministic hash of the file contents of a directory";
    homepage = "https://github.com/to-mc/checksumdir";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
