{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, libsodium
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "libnacl";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "saltstack";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-phECLGDcBfDi/r2y0eGtqgIX/hvirtBqO8UUvEJ66zo=";
  };

  nativeBuildInputs = [ poetry-core ];

  buildInputs = [ libsodium ];

  postPatch =
    let soext = stdenv.hostPlatform.extensions.sharedLibrary; in
    ''
      substituteInPlace "./libnacl/__init__.py" \
        --replace \
          "l_path = ctypes.util.find_library('sodium')" \
          "l_path = None" \
        --replace \
          "ctypes.cdll.LoadLibrary('libsodium${soext}')" \
          "ctypes.cdll.LoadLibrary('${libsodium}/lib/libsodium${soext}')"
    '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "libnacl" ];

  meta = with lib; {
    description = "Python bindings for libsodium based on ctypes";
    homepage = "https://libnacl.readthedocs.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ xvapx ];
  };
}
