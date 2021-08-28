{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, libsodium
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "libnacl";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "saltstack";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nttR9PQimhqd2pByJ5IJzJ4RmSI4y7lcX7a7jcK+vqc=";
  };

  buildInputs = [ libsodium ];

  postPatch =
    let soext = stdenv.hostPlatform.extensions.sharedLibrary; in
    ''
      substituteInPlace "./libnacl/__init__.py" --replace \
        "ctypes.cdll.LoadLibrary('libsodium${soext}')" \
        "ctypes.cdll.LoadLibrary('${libsodium}/lib/libsodium${soext}')"
    '';

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "libnacl" ];

  meta = with lib; {
    description = "Python bindings for libsodium based on ctypes";
    homepage = "https://libnacl.readthedocs.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xvapx ];
  };
}
