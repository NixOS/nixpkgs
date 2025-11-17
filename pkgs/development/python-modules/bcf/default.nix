{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
buildPythonPackage rec {
  pname = "bcf";
  version = "1.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hardwario";
    repo = "bch-firmware-tool";
    rev = "v${version}";
    sha256 = "sha256-xKggVEN3O0umDEt358xc+79/SEVm2peMjfFHGTppTEo=";
  };

  postPatch = ''
    sed -ri 's/@@VERSION@@/${version}/g' \
      bcf/__init__.py setup.py
  '';

  propagatedBuildInputs = [
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

  meta = with lib; {
    homepage = "https://github.com/hardwario/bch-firmware-tool";
    description = "HARDWARIO Firmware Tool";
    mainProgram = "bcf";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
