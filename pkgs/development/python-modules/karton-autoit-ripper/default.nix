{
  lib,
  autoit-ripper,
  buildPythonPackage,
  fetchFromGitHub,
  karton-core,
  malduck,
  pythonOlder,
  regex,
}:

buildPythonPackage rec {
  pname = "karton-autoit-ripper";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-D+M3JsIN8LUWg8GVweEzySHI7KaBb6cNHHn4pXoq55M=";
  };

  propagatedBuildInputs = [
    autoit-ripper
    karton-core
    malduck
    regex
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "autoit-ripper==" "autoit-ripper>=" \
      --replace "malduck==" "malduck>=" \
      --replace "regex==" "regex>="
  '';

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "karton.autoit_ripper" ];

  meta = with lib; {
    description = "AutoIt script ripper for Karton framework";
    mainProgram = "karton-autoit-ripper";
    homepage = "https://github.com/CERT-Polska/karton-autoit-ripper";
    changelog = "https://github.com/CERT-Polska/karton-autoit-ripper/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
