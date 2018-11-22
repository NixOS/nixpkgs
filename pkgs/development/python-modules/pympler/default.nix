{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Pympler";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c262ceca4dac67b8b523956833c52443420eabc3321a07185990b358b8ba13a7";
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
