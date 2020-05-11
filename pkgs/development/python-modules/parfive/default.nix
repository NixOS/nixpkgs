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
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90dfb05d0a65d00669f5245371a4b33cbebcb5cfba86f4aad7f956984394eefd";
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
