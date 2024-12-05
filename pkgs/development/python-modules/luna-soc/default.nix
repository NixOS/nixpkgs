{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  luna-usb,
}:

buildPythonPackage rec {
  pname = "luna-soc";
  version = "0.2.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "luna-soc";
    rev = "refs/tags/${version}";
    hash = "sha256-P8P32hM1cVXENcDpCrmPe8BvkMCWdeEgHwbIU94uLe8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [ luna-usb ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "luna_soc"
  ];

  meta = {
    changelog = "https://github.com/greatscottgadgets/luna-soc/releases/tag/${version}";
    description = "Amaranth HDL library for building USB-capable SoC designs";
    homepage = "https://github.com/greatscottgadgets/luna-soc";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
