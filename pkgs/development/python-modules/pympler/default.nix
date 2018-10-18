{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Pympler";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mhyxqlkha98y8mi5zqcjg23r30mgdjdzs05lghbmqfdyvzjh1a3";
  };

 # Remove test asizeof.flatsize(), broken and can be missed as
 # test is only useful on python 2.5, see https://github.com/pympler/pympler/issues/22
 patchPhase = ''
   substituteInPlace ./test/asizeof/test_asizeof.py --replace "n, e = test_flatsize" "#n, e = test_flatsize"
   substituteInPlace ./test/asizeof/test_asizeof.py --replace "self.assert_(n," "#self.assert_(n,"
   substituteInPlace ./test/asizeof/test_asizeof.py --replace "self.assert_(not e" "#self.assert_(not e"
  '';

  doCheck = stdenv.hostPlatform.isLinux;

  meta = with stdenv.lib; {
    description = "Tool to measure, monitor and analyze memory behavior";
    homepage = https://pythonhosted.org/Pympler/;
    license = licenses.asl20;
  };

}
