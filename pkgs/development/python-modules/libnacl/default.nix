{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, libsodium }:

buildPythonPackage rec {
  pname = "libnacl";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "saltstack";
    repo = pname;
    rev = "v${version}";
    sha256 = "10rpim9lf0qd861a3miq8iqg8w87slqwqni7nq66h72jdk130axg";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ libsodium ];

  postPatch =
    let soext = stdenv.hostPlatform.extensions.sharedLibrary; in ''
    substituteInPlace "./libnacl/__init__.py" --replace "ctypes.cdll.LoadLibrary('libsodium${soext}')" "ctypes.cdll.LoadLibrary('${libsodium}/lib/libsodium${soext}')"
  '';

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ xvapx ];
    description = "Python bindings for libsodium based on ctypes";
    homepage = https://pypi.python.org/pypi/libnacl;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
