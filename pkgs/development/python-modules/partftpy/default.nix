# mostly copied from https://github.com/9001/copyparty/blob/hovudstraum/contrib/package/nix/partftpy/default.nix
{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage rec {
  pname = "partftpy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "9001";
    repo = "partftpy";
    tag = "v${version}";
    hash = "sha256-9+zY9OpGQ3LbORwtjEYZF1lRaQCLmSyQ9KQdxaOzMuM=";
  };

  postPatch = ''
    # poor setuptools gets confused by this dir
    rm -r t
  '';

  pyproject = true;

  build-system = [ setuptools ];

  pythonImportsCheck = [ "partftpy.TftpServer" ];

  meta = {
    description = "Pure Python TFTP library (copyparty fork of tftpy)";
    homepage = "https://github.com/9001/partftpy";
    changelog = "https://github.com/9001/partftpy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.shelvacu ];
    platforms = lib.platforms.all;
  };
}
