{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "process-tests";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15yrgr1hb7i0fq31dh6k8hmc3jnk6yn5nh4xh3gmszk9vag5zrqk";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tools for testing processes";
    license = licenses.bsd2;
    homepage = "https://github.com/ionelmc/python-process-tests";
  };

}
