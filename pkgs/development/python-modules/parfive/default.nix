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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "faa60c34dfbd080f011c1af0587f932874dcdf602d0336227d540899dbc41b50";
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
