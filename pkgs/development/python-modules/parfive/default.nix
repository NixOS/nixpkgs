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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15dc8466922c8fb1f814d3f7c3f3656191ac17b38fd7cc3350b9bf726e144ebb";
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
    homepage = https://parfive.readthedocs.io/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
