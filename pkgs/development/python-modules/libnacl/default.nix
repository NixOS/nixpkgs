{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, libsodium }:

buildPythonPackage rec {
  pname = "libnacl";
  version = "1.6.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "saltstack";
    repo = pname;
    rev = "v${version}";
    sha256 = "0iaql3mrj3hf48km8177bi6nmjdar26kmqjc3jw8mrjc940v99fk";
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
    homepage = https://pypi.python.org/pypi/libnacl;
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
