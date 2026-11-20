{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  appdirs,
  click,
  colorama,
  intelhex,
  packaging,
  pyaml,
  pyftdi,
  pyserial,
  requests,
  schema,
}:
buildPythonPackage (finalAttrs: {
  pname = "bcf";
  version = "1.9.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-firmware-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xKggVEN3O0umDEt358xc+79/SEVm2peMjfFHGTppTEo=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    sed -ri 's/@@VERSION@@/${finalAttrs.version}/g' \
      bcf/__init__.py setup.py
  '';

  dependencies = [
    appdirs
    click
    colorama
    intelhex
    packaging
    pyaml
    pyftdi
    pyserial
    requests
    schema
  ];

  pythonImportsCheck = [ "bcf" ];
  doCheck = false; # Project provides no tests

  meta = {
    homepage = "https://github.com/hardwario/bch-firmware-tool";
    description = "HARDWARIO Firmware Tool";
    mainProgram = "bcf";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cynerd ];
  };
})
