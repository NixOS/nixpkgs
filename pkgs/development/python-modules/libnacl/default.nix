{ stdenv, buildPythonPackage, fetchPypi, pytest, libsodium }:

buildPythonPackage rec {
  pname = "libnacl";
  version = "1.5.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e44e9436e7245b0d8b7322bef67750cb7757834d7ccdb7eb7b723b4813df84fb";
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
