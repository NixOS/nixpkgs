{ stdenv, fetchPypi, buildPythonPackage, click, redis }:

buildPythonPackage rec {
  pname = "rq";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60509898c9ebc40e4155fde8bf88a204ed1914cc9e1cde3d19188b1c5bd5efbd";
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

