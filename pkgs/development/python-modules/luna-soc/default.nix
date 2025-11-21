{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  luna-usb,
}:

buildPythonPackage rec {
  pname = "luna-soc";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "luna-soc";
    tag = version;
    hash = "sha256-Rks1wC0CR5FSu4TrE1thzolT3QBd0yh7q+SxZ1U+pB4=";
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
    changelog = "https://github.com/greatscottgadgets/luna-soc/releases/tag/${src.tag}";
    description = "Amaranth HDL library for building USB-capable SoC designs";
    homepage = "https://github.com/greatscottgadgets/luna-soc";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ carlossless ];
  };
}
