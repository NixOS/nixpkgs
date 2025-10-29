{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pcsclite,
  pkg-config,
  pytestCheckHook,
  setuptools,
  stdenv,
  swig,
}:

buildPythonPackage rec {
  pname = "pyscard";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LudovicRousseau";
    repo = "pyscard";
    tag = version;
    hash = "sha256-rz3m8eVbmJUMcQFuEMZwF3k/ES75KcNA8R+xix+Mgq8=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ swig ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ pcsclite ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["setuptools","swig"]' 'requires = ["setuptools"]'
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace setup.py --replace-fail "pkg-config" "$PKG_CONFIG"
    substituteInPlace src/smartcard/scard/winscarddll.c \
      --replace-fail "libpcsclite.so.1" \
                "${lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  meta = {
    description = "Smartcard library for python";
    homepage = "https://pyscard.sourceforge.io/";
    changelog = "https://github.com/LudovicRousseau/pyscard/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ layus ];
  };
}
