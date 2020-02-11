{ stdenv, fetchPypi, buildPythonPackage, click, redis }:

buildPythonPackage rec {
  pname = "rq";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dk664lzjhj0rk4ffpv29mbcr7vh41ph1sx7ngszk3744gh1nshp";
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

