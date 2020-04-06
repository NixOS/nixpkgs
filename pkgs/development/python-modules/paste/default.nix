{ stdenv
, buildPythonPackage
, fetchPypi
, six
, pytestrunner
, pytest
}:

buildPythonPackage rec {
  pname = "paste";
  version = "3.2.2";

  src = fetchPypi {
    pname = "Paste";
    inherit version;
    sha256 = "15p95br9x7zjy0cckdy6xmhfg61cg49rhi75jd00svrnz234s7qb";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestrunner pytest ];

  # Certain tests require network
  checkPhase = ''
    py.test -k "not test_cgiapp and not test_proxy"
  '';

  meta = with stdenv.lib; {
    description = "Tools for using a Web Server Gateway Interface stack";
    homepage = http://pythonpaste.org/;
    license = licenses.mit;
  };

}
