{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  configparser,
  paramiko,
  pycryptodomex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "exscript";
  baseVersion = "2.6";
  version = baseVersion + "-unstable-2023-08-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "knipknap";
    repo = "exscript";
    rev = "9d5b035f3de4237dc6ecb7437b3ebd0c162bb6ec";
    hash = "sha256-hbSUS9YnAZdD9H3ZTJhviG44O1hAmR/R9W2VyaVUlPw=";
  };

  patches = [
    ./0001-remove-future-dependency.patch
  ];

  build-tools = [ setuptools ];

  dependencies = [
    configparser
    paramiko
    pycryptodomex
    setuptools
  ];

  postPatch = ''
    substituteInPlace Exscript/version.py \
      --replace-fail 'DEVELOPMENT' '${baseVersion}'
  '';

  meta = {
    description = "A Python module making Telnet and SSH easy";
    homepage = "https://github.com/knipknap/exscript";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
}
