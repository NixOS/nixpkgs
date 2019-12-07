{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Pympler";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08mrpnb6cv2nvfncvr8a9a8bpwhnasa924anapnjvnaw5jcd4k7p";
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
