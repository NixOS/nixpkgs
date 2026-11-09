{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-axolotl-curve25519";
  version = "0.4.1.post2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BwWmYpfr0vUIpg3JTiKIHHVDAeuB25OWMyL2s73LY6M=";
  };

  patches = [
    # https://github.com/tgalal/python-axolotl-curve25519/pull/26
    (fetchpatch {
      url = "https://github.com/tgalal/python-axolotl-curve25519/commit/901f4fb12e1290b72fbd26ea1f40755b079fa241.patch";
      hash = "sha256-hdhaOysRXI9q5D9e/bfy0887bpEFSvUyrbl32nBgteQ=";
    })
  ];

  build-system = [ setuptools ];

  meta = {
    homepage = "https://github.com/tgalal/python-axolotl-curve25519";
    description = "Curve25519 with ed25519 signatures";
    maintainers = [ ];
    license = lib.licenses.gpl3;
  };
}
