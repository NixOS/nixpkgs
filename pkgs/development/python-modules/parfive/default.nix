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
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c411fd7269a49d1c72a964e97de474ec082115777b363aeed98a6595f90b8676";
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
