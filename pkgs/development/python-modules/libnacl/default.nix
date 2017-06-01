{ stdenv, buildPythonPackage, fetchPypi, pytest, libsodium }:

buildPythonPackage rec {
  pname = "libnacl";
  version = "1.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ph042x0cfysj16mmjif40pxn505rg5c9n94s972dgc0mfgvrwhs";
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
