{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "karton-asciimagic";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sY5ik9efzLBa6Fbh17Vh4q7PlwOGYjuodU9yvp/8E3k=";
  };

  propagatedBuildInputs = [
    karton-core
  ];

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "karton.asciimagic" ];

  meta = with lib; {
    description = "Decoders for ascii-encoded executables for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-asciimagic";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
