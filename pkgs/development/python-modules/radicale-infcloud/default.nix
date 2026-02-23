{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  radicale,
  setuptools,
}:

buildPythonPackage {
  pname = "radicale-infcloud";
  version = "unstable-2022-04-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Unrud";
    repo = "RadicaleInfCloud";
    rev = "53d3a95af5b58cfa3242cef645f8d40c731a7d95";
    hash = "sha256-xzBWIx2OOkCtBjlff1Z0VqgMhxWtgiOKutXUadT3tIo=";
  };

  patches = [
    # Radicale >=3.2 compatibility fix: https://github.com/Unrud/RadicaleInfCloud/pull/27
    (fetchpatch {
      url = "https://github.com/Unrud/RadicaleInfCloud/commit/c7487d34a544a499b751fdc92b01196edef599c6.patch";
      sha256 = "sha256-H5cSKFYQhC7+zpdbi0ojU8UlRJnldXtxv6d8gJ8D39w=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ radicale ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "radicale" ];

  meta = {
    homepage = "https://github.com/Unrud/RadicaleInfCloud/";
    description = "Integrate InfCloud into Radicale's web interface";
    license = with lib.licenses; [
      agpl3Plus
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
