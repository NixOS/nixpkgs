{ lib
, buildPythonPackage
, fetchPypi
, tqdm
, aiohttp
, pytest
, setuptools_scm
, pytest-localserver
, pytest-socket
, pytest-asyncio
, aioftp
}:

buildPythonPackage rec {
  pname = "parfive";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "118a0994bbb9536fd4574995a8485b6c4b97db247c55bc86ae4f4ae8fd9b0add";
  };

  buildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    tqdm
    aiohttp
    aioftp
  ];

  checkInputs = [
    pytest
    pytest-localserver
    pytest-socket
    pytest-asyncio
  ];

  checkPhase = ''
    # these two tests require network connection
    pytest parfive -k "not test_ftp and not test_ftp_http"
  '';

  meta = with lib; {
    description = "A HTTP and FTP parallel file downloader";
    homepage = "https://parfive.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
