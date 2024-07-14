{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pyfttt";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RVra0Lrc4BX1vQhr09XH29l/XBfG7dwF1VoMxBI7OII=";
  };

  propagatedBuildInputs = [ requests ];

  # tests need a server to run against
  doCheck = false;

  meta = with lib; {
    description = "Package for sending events to the IFTTT Webhooks Channel";
    mainProgram = "pyfttt";
    homepage = "https://github.com/briandconnelly/pyfttt";
    maintainers = with maintainers; [ peterhoeg ];
    license = licenses.bsd2;
  };
}
