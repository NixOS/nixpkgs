{ stdenv, fetchPypi, buildPythonPackage, click, redis }:

buildPythonPackage rec {
  pname = "rq";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f680c52c7079266465d5e5c49679fab0d14db11d70fec6f1470423408b6bbcf6";
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

