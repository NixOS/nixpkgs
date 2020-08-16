{ stdenv, fetchPypi, buildPythonPackage, click, redis }:

buildPythonPackage rec {
  pname = "rq";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "370fc800903c226b898a10174e069a23077b74b22297b4b20e925ca82fcd9471";
  };

  # test require a running redis rerver, which is something we can't do yet
  doCheck = false;

  propagatedBuildInputs = [ click redis ];

  meta = with stdenv.lib; {
    description = "A simple, lightweight library for creating background jobs, and processing them";
    homepage = "https://github.com/nvie/rq/";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd2;
  };
}

