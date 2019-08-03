{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pysendfile";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05qf0m32isflln1zjgxlpw0wf469lj86vdwwqyizp1h94x5l22ji";
  };

  checkPhase = ''
    # this test takes too long
    sed -i 's/test_big_file/noop/' test/test_sendfile.py
    ${python.executable} test/test_sendfile.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/giampaolo/pysendfile";
    description = "A Python interface to sendfile(2)";
    license = licenses.mit;
  };

}
