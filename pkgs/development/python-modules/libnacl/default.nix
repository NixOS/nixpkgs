{ stdenv, buildPythonPackage, fetchPypi, pytest, libsodium }:

buildPythonPackage rec {
  pname = "libnacl";
  version = "1.5.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c58390b0d191db948fc9ab681f07fdfce2a573cd012356bada47d56795d00ee2";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ libsodium ];

  postPatch = ''
    substituteInPlace "./libnacl/__init__.py" --replace "ctypes.cdll.LoadLibrary('libsodium.so')" "ctypes.cdll.LoadLibrary('${libsodium}/lib/libsodium.so')"
  '';

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ xvapx ];
    description = "Python bindings for libsodium based on ctypes";
    homepage = "https://pypi.python.org/pypi/libnacl";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
