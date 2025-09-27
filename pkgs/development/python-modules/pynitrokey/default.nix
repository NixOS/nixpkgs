{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  installShellFiles,
  libnitrokey,
  poetry-core,
  cffi,
  click,
  cryptography,
  fido2,
  hidapi,
  intelhex,
  nkdfu,
  pyusb,
  requests,
  tqdm,
  tlv8,
  semver,
  nethsm,
  nitrokey,
  pyscard,
}:

let
  pname = "pynitrokey";
  version = "0.10.0";
  mainProgram = "nitropy";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kr6VtBADLvXUva7csbsHujGzBfRG1atJLF7qbIWmToM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = [ poetry-core ];

  dependencies = [
    cffi
    click
    cryptography
    fido2
    hidapi
    intelhex
    nkdfu
    nitrokey
    pyusb
    requests
    tqdm
    tlv8
    semver
    nethsm
  ];

  optional-dependencies = {
    pcsc = [
      pyscard
    ];
  };

  pythonRelaxDeps = true;

  # libnitrokey is not propagated to users of the pynitrokey Python package.
  # It is only usable from the wrapped bin/nitropy
  makeWrapperArgs = [ "--set LIBNK_PATH ${lib.makeLibraryPath [ libnitrokey ]}" ];

  pythonImportsCheck = [ "pynitrokey" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${mainProgram} \
      --bash <(_NITROPY_COMPLETE=bash_source $out/bin/${mainProgram}) \
      --zsh <(_NITROPY_COMPLETE=zsh_source $out/bin/${mainProgram}) \
      --fish <(_NITROPY_COMPLETE=fish_source $out/bin/${mainProgram})
  '';

  meta = with lib; {
    description = "Python client for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/pynitrokey";
    changelog = "https://github.com/Nitrokey/pynitrokey/releases/tag/v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      frogamic
    ];
    inherit mainProgram;
  };
}
