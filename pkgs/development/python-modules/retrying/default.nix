{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "retrying";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NF2oxXZb2YKx0ZFd65EC/T0fetFr2EqXALhfZNJOjz4=";
  };

  propagatedBuildInputs = [ six ];

  # doesn't ship tests in tarball
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/rholder/retrying";
    description = "General-purpose retrying library";
    license = licenses.asl20;
  };

}
