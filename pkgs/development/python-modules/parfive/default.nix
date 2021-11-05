{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, aioftp
, aiohttp
, tqdm
, aiofiles
, pytestCheckHook
, pytest-localserver
, pytest-socket
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "parfive";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f36128e8a93f3494ce3de8af883eeba4bd651ab228682810a46ec4b7897a84b3";
  };

  buildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    tqdm
    aiohttp
    aioftp
  ];

  pythonImportsCheck = [
    "parfive"
  ];

  checkInputs = [
    aiofiles
    pytest-asyncio
    pytest-localserver
    pytest-socket
    pytestCheckHook
  ];

  disabledTests = [
    "test_ftp"
    "test_ftp_pasv_command"
    "test_ftp_http"
  ];

  meta = with lib; {
    description = "A HTTP and FTP parallel file downloader";
    homepage = "https://parfive.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
