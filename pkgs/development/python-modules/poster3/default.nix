{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, paste
, webob
, pyopenssl
}:

buildPythonPackage rec {
  pname = "poster3";
  version = "0.8.1";
  format = "wheel"; # only redistributable available

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py3";
    sha256 = "1b27d7d63e3191e5d7238631fc828e4493590e94dcea034e386c079d853cce14";
  };

  checkInputs = [
    paste
    webob
    pyopenssl
  ];

  meta = with lib; {
    description = "Streaming HTTP uploads and multipart/form-data encoding";
    homepage = https://atlee.ca/software/poster/;
    license = licenses.mit;
    maintainers = with maintainers; [ WhittlesJr ];
  };
}
