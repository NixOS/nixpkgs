{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  varint,
  base58,
  netaddr,
  idna,
  py-cid,
  py-multicodec,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py-multiaddr";
  version = "0.0.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = "py-multiaddr";
    tag = "v${version}";
    hash = "sha256-N46D2H3RG6rtdBrSyDjh8UxD+Ph/FXEa4FcEI2uz4y8=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    varint
    base58
    netaddr
    idna
    py-cid
    py-multicodec
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multiaddr" ];

  meta = {
    description = "Composable and future-proof network addresses";
    homepage = "https://github.com/multiformats/py-multiaddr";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
