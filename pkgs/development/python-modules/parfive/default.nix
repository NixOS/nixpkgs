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
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5793fdf9859a9a9fc93f033db9dc067a89626910355a14bbe425feb3956df6db";
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
