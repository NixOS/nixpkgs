{ lib, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Pympler";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2cbe7df622117af890249f2dea884eb702108a12d729d264b7c5983a6e06e47";
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
