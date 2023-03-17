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
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kIIR+cXLUtyLJ5YmhyCV88zhXahok/U7QXbezt3PyF0=";
  };

  buildInputs = [
    setuptools-scm
  ];

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
