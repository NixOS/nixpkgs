{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  cython,
  poetry-core,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rencode";
  version = "1.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aresch";
    repo = "rencode";
    tag = "v${version}";
    hash = "sha256-k2b6DoKwNeQBkmqSRXqaRTjK7CVX6IKuXCLG9lBdLLY=";
  };

  patches = [
    # backport fix for -msse being passed on aarch64-linux
    (fetchpatch {
      url = "https://github.com/aresch/rencode/commit/591b9f4d85d7e2d4f4e99441475ef15366389be2.patch";
      hash = "sha256-KhfawtYa4CnYiVzBYdtMn/JRkeqCLJetHvLEm1YVOe4=";
    })
    # do not pass -march=native etc. on x86_64
    (fetchpatch {
      url = "https://github.com/aresch/rencode/commit/e7ec8ea718e73a8fee7dbc007c262e1584f7f94b.patch";
      hash = "sha256-gNYjxBsMN1p4IAmutV73JF8yCj0iz3DIl7kg7WrBdbs=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
    setuptools
    cython
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # import from $out
    rm -r rencode
  '';

  meta = with lib; {
    homepage = "https://github.com/aresch/rencode";
    description = "Fast (basic) object serialization similar to bencode";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
