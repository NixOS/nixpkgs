{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "pyfttt";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10iq7c9c832ssl2xrvf62xf7znfvqzax6sq8ppsibq6wpb8dlnj5";
  };

  propagatedBuildInputs = [ requests ];

  # tests need a server to run against
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Package for sending events to the IFTTT Webhooks Channel";
    homepage = "https://github.com/briandconnelly/pyfttt";
    maintainers = with maintainers; [ peterhoeg ];
    license = licenses.bsd2;
  };
}
