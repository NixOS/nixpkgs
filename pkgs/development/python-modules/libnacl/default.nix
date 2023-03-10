{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # Fixes build on 32-bit platforms
    (fetchpatch {
      name = "fix-crypto_kdf_derive_from_key-32bit.patch";
      url = "https://github.com/saltstack/libnacl/commit/e8a1f95ee1d4d0806fb6aee793dcf308b05d485d.patch";
      sha256 = "sha256-z6TAVNfPcuWZ/hRgk6Aa8I1IGzne7/NYnUOOQ3TjGVU=";
    })
  ];

  buildInputs = [ libsodium ];

  postPatch =
    let soext = stdenv.hostPlatform.extensions.sharedLibrary; in
    ''
      substituteInPlace "./libnacl/__init__.py" --replace \
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
