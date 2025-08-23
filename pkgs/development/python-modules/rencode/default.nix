{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
