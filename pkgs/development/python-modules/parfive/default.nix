{ lib
, buildPythonPackage
, fetchPypi
, tqdm
, aiohttp
, pytest
, setuptools-scm
, pytest-localserver
, pytest-socket
, pytest-asyncio
, aioftp
}:

buildPythonPackage rec {
  pname = "parfive";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3067e6ca9d6fb88a10958338360bd9c47edfd8ab11098d4c601f7f2887edadd";
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
