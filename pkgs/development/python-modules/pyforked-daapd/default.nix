{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "pyforked-daapd";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "uvjustin";
    repo = "pyforked-daapd";
    tag = "v${version}";
    hash = "sha256-dPDhBe/CEslgEomt5HgAf4nbW0izXM5fSNRe96ULYlg=";
  };

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [
    "pyforked_daapd"
  ];

  meta = {
    description = "Library to interface with an Owntone server";
    homepage = "https://github.com/uvjustin/pyforked-daapd";
    changelog = "https://github.com/uvjustin/pyforked-daapd/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hensoko
    ];
  };
}
