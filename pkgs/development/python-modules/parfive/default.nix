{ lib
, buildPythonPackage
, fetchPypi
, tqdm
, aiohttp
, pytestCheckHook
, setuptools-scm
, pytest-localserver
, pytest-socket
, pytest-asyncio
, aioftp
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

  checkInputs = [
    pytestCheckHook
    pytest-localserver
    pytest-socket
    pytest-asyncio
  ];

  disabledTests = [
    # no network access
    "test_ftp"
    "aiofiles"
  ];

  meta = with lib; {
    description = "A HTTP and FTP parallel file downloader";
    homepage = "https://parfive.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
