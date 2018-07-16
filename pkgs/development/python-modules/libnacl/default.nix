{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, libsodium }:

buildPythonPackage rec {
  pname = "libnacl";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "saltstack";
    repo = pname;
    rev = "v${version}";
    sha256 = "05iamhbsqm8binqhc2zchfqdkajlx2icf8xl5vkd5fbrhw6yylad";
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
