{ lib
, aiofiles
, aioftp
, aiohttp
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytest-localserver
, pytest-socket
, pytestCheckHook
, pythonOlder
, setuptools-scm
, tqdm
}:

buildPythonPackage rec {
  pname = "parfive";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f36128e8a93f3494ce3de8af883eeba4bd651ab228682810a46ec4b7897a84b3";
  };

  buildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aioftp
    aiohttp
    tqdm
  ];

  checkInputs = [
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

  pythonImportsCheck = [
    "parfive"
  ];

  meta = with lib; {
    description = "A HTTP and FTP parallel file downloader";
    homepage = "https://parfive.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
