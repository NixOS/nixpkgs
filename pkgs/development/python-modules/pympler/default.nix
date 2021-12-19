{ lib, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Pympler";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2e82c3e33835d0378ed95fffabc00806f4070f00decaa38b340ca99b1aca25c";
  };

  postPatch = ''
   rm test/asizeof/test_asizeof.py
  '';

  doCheck = stdenv.hostPlatform.isLinux;

  meta = with lib; {
    description = "Tool to measure, monitor and analyze memory behavior";
    homepage = "https://pythonhosted.org/Pympler/";
    license = licenses.asl20;
  };

}
