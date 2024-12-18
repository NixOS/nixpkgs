{
  lib,
  aiofiles,
  aioftp,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pytest-asyncio,
  pytest-localserver,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  tqdm,
}:

buildPythonPackage rec {
  pname = "parfive";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zWy0GSQhMHMM9B1M9vKE6/UPGnHObJUI4EZ+yY8X3I4=";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    aioftp
    aiohttp
    tqdm
  ];

  nativeCheckInputs = [
    aiofiles
    pytest-asyncio
    pytest-localserver
    pytest-socket
    pytestCheckHook
  ];

  disabledTests = [
    # Requires network access
    "test_ftp"
    "test_ftp_pasv_command"
    "test_ftp_http"
  ];

  pythonImportsCheck = [ "parfive" ];

  meta = with lib; {
    description = "HTTP and FTP parallel file downloader";
    mainProgram = "parfive";
    homepage = "https://parfive.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
