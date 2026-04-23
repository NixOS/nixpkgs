{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  setuptools,
  unzip,
}:

let
  version = "0.1.0";

  xdia-bin = fetchurl {
    url = "https://github.com/mborgerson/xdia/releases/download/v${version}/xdia.zip";
    hash = "sha256-rtKcSZoL8OUo2l1B/WJYACIu+DFEqahfTvbjeNsmq8s=";
  };

  xdialdr-bin = fetchurl {
    url = "https://github.com/mborgerson/xdia/releases/download/v${version}/xdialdr.tar.xz";
    hash = "sha256-rXL7uVl+TJYYhKrqzkF7YK0nZ+rwSnGKsTyxAN/mlYQ=";
  };
in
buildPythonPackage {
  pname = "pyxdia";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = "xdia";
    tag = "v${version}";
    hash = "sha256-VfA4xaszdd8ZhPdbEsawDzzl2F4tM4vk8uQIuDpULE0=";
  };

  sourceRoot = "source/pyxdia";

  build-system = [ setuptools ];

  nativeBuildInputs = [ unzip ];

  # Pre-place the xdia binaries so the build's check_xdia_install step finds
  # them and doesn't try to download from the internet.
  # xdialdr is a statically-linked Linux binary that runs xdia.exe (a Windows
  # PE binary) via a built-in compatibility layer.
  preBuild = ''
    mkdir -p pyxdia/bin
    unzip ${xdia-bin} -d pyxdia/bin
    tar -xf ${xdialdr-bin} -C pyxdia/bin
    chmod +x pyxdia/bin/xdialdr
  '';

  pythonImportsCheck = [ "pyxdia" ];

  meta = {
    description = "Extract useful program information from PDB files";
    homepage = "https://github.com/mborgerson/xdia";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
