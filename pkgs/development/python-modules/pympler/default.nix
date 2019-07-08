{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Pympler";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ki7bqp1h9l1xc2k1h4vjyzsgs20i8ingvcdhszyi72s28wyf4bs";
  };

  postPatch = ''
   rm test/asizeof/test_asizeof.py
  '';

  doCheck = stdenv.hostPlatform.isLinux;

  meta = with stdenv.lib; {
    description = "Tool to measure, monitor and analyze memory behavior";
    homepage = https://pythonhosted.org/Pympler/;
    license = licenses.asl20;
  };

}
