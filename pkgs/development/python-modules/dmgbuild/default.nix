{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  ds-store,
  mac-alias,
}:

buildPythonPackage rec {
  pname = "dmgbuild";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dmgbuild";
    repo = "dmgbuild";
    tag = "v${version}";
    hash = "sha256-m73IUB9d5HWtj/EnzKrX15tnjFqgeO4cFmvaBvCuR5w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==84.0.0" "setuptools" \
      --replace-fail "setuptools_scm==10.3.4" "setuptools_scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    ds-store
    mac-alias
  ];

  pythonImportsCheck = [
    "dmgbuild"
  ];

  # tests invoke /usr/sbin/diskutil which requires macOS system services unavailable in the sandbox
  doCheck = false;

  meta = {
    description = "MacOS command line utility to build disk images";
    homepage = "https://github.com/dmgbuild/dmgbuild";
    changelog = "https://github.com/dmgbuild/dmgbuild/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "dmgbuild";
    platforms = lib.platforms.darwin;
  };
}
