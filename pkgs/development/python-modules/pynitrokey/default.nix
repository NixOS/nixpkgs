{
  lib,
  buildPythonPackage,
  fetchPypi,
  installShellFiles,
  libnitrokey,
  flit-core,
  certifi,
  cffi,
  click,
  cryptography,
  ecdsa,
  fido2,
  intelhex,
  nkdfu,
  python-dateutil,
  pyusb,
  requests,
  spsdk,
  tqdm,
  tlv8,
  typing-extensions,
  pyserial,
  protobuf,
  click-aliases,
  semver,
  nethsm,
  importlib-metadata,
}:

let
  pname = "pynitrokey";
  version = "0.4.47";
  mainProgram = "nitropy";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WOHDskGAZGhiU48JGV0yDhWIpFELFLHhn9g5sbchKKg=";
  };

  propagatedBuildInputs = [
    certifi
    cffi
    click
    cryptography
    ecdsa
    fido2
    intelhex
    nkdfu
    python-dateutil
    pyusb
    requests
    spsdk
    tqdm
    tlv8
    typing-extensions
    pyserial
    protobuf
    click-aliases
    semver
    nethsm
    importlib-metadata
  ];

  nativeBuildInputs = [
    flit-core
    installShellFiles
  ];

  pythonRelaxDeps = true;

  # pythonRelaxDepsHook runs in postBuild so cannot be used
  pypaBuildFlags = [ "--skip-dependency-check" ];

  # libnitrokey is not propagated to users of the pynitrokey Python package.
  # It is only usable from the wrapped bin/nitropy
  makeWrapperArgs = [ "--set LIBNK_PATH ${lib.makeLibraryPath [ libnitrokey ]}" ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pynitrokey" ];

  postInstall = ''
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
      raitobezarius
    ];
    inherit mainProgram;
  };
}
