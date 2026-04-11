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
    sha256 = "10iq7c9c832ssl2xrvf62xf7znfvqzax6sq8ppsibq6wpb8dlnj5";
  };

  propagatedBuildInputs = [ requests ];

  # tests need a server to run against
  doCheck = false;

  meta = {
    description = "Package for sending events to the IFTTT Webhooks Channel";
    mainProgram = "pyfttt";
    homepage = "https://github.com/briandconnelly/pyfttt";
    maintainers = with lib.maintainers; [ peterhoeg ];
    license = lib.licenses.bsd2;
  };
}
