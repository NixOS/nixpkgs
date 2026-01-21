{
  lib,
  base58,
  buildPythonPackage,
  fetchFromGitHub,
  morphys,
  pytestCheckHook,
  six,
  varint,
}:

buildPythonPackage rec {
  pname = "py-multihash";
  version = "3.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = "py-multihash";
    tag = "v${version}";
    hash = "sha256-hdjJJh77P4dJQAIGTlPGolz1qDumvNOaIMyfxmWMzUk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  propagatedBuildInputs = [
    base58
    morphys
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
