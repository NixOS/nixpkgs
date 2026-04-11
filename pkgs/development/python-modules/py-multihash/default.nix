{
  lib,
  base58,
  blake3,
  buildPythonPackage,
  fetchFromGitHub,
  mmh3,
  morphys,
  pytestCheckHook,
  setuptools,
  six,
  varint,
}:

buildPythonPackage rec {
  pname = "py-multihash";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = "py-multihash";
    tag = "v${version}";
    hash = "sha256-hdjJJh77P4dJQAIGTlPGolz1qDumvNOaIMyfxmWMzUk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    base58
    blake3
    morphys
    mmh3
    six
    varint
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multihash" ];

  meta = {
    description = "Self describing hashes - for future proofing";
    homepage = "https://github.com/multiformats/py-multihash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
}
