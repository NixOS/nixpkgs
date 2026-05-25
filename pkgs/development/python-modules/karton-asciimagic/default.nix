{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  karton-core,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "karton-asciimagic";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "karton-asciimagic";
    tag = "v${version}";
    hash = "sha256-sY5ik9efzLBa6Fbh17Vh4q7PlwOGYjuodU9yvp/8E3k=";
  };

  propagatedBuildInputs = [ karton-core ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "karton.asciimagic" ];

  meta = {
    description = "Decoders for ascii-encoded executables for the Karton framework";
    mainProgram = "karton-asciimagic";
    homepage = "https://github.com/CERT-Polska/karton-asciimagic";
    changelog = "https://github.com/CERT-Polska/karton-asciimagic/releases/tag/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
