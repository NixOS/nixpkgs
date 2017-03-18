{ stdenv, buildPythonPackage, fetchPypi, pkgs }:

buildPythonPackage rec {
  pname = "libnacl";
  version = "1.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ph042x0cfysj16mmjif40pxn505rg5c9n94s972dgc0mfgvrwhs";
  };

  propagatedBuildInputs = [ pkgs.libsodium ];

  postPatch = ''
    substituteInPlace "./libnacl/__init__.py" --replace "ctypes.cdll.LoadLibrary('libsodium.so')" "ctypes.cdll.LoadLibrary('${pkgs.libsodium}/lib/libsodium.so')"
  '';

  meta = {
    maintainers = with stdenv.lib.maintainers; [ xvapx ];
    description = "Python bindings for libsodium based on ctypes";
    homepage = "https://pypi.python.org/pypi/libnacl";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}