{ stdenv, fetchPypi, buildPythonPackage, isPy27, defusedxml, pytest }:

buildPythonPackage rec {
  pname = "Py3AMF";
  version = "0.8.9";

  # according to setup.py
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pmh6p7mqdjmy2yj4mv6s1vnf7l9sn326dr6465mxhd6qz6mmgzi";
  };

  propagatedBuildInputs = [ defusedxml ];

  checkInputs = [ pytest ];
  # test_wsgi: attempts network access
  # test_remoting: obsolete usage of assertRaises
  checkPhase = ''
    pytest pyamf/tests \
      --ignore=pyamf/tests/gateway/test_wsgi.py \
      --ignore=pyamf/tests/test_remoting.py
  '';

  meta = with stdenv.lib; {
    description = "Py3AMF is fork of PyAMF to support Python3";
    homepage = https://github.com/StdCarrot/Py3AMF;
    license = licenses.mit;
  };
}
