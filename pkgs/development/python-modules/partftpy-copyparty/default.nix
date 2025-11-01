# mostly copied from https://github.com/9001/copyparty/blob/hovudstraum/contrib/package/nix/partftpy/default.nix
{
  lib,
  buildPythonPackage,
  fetchurl,
  setuptools,
}:
buildPythonPackage rec {
  pname = "partftpy-copyparty";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/9001/partftpy/releases/download/v${version}/partftpy-${version}.tar.gz";
    hash = "sha256-5Q2zyuJ892PGZmb+YXg0ZPW/DK8RDL1uE0j5HPd4We0=";
  };

  pyproject = true;

  build-system = [ setuptools ];

  pythonImportsCheck = [ "partftpy.TftpServer" ];

  meta = {
    description = "Pure Python TFTP library (copyparty edition)";
    homepage = "https://github.com/9001/partftpy";
    changelog = "https://github.com/9001/partftpy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.shelvacu ];
    platforms = lib.platforms.all;
  };
}
