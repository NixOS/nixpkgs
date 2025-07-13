{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  installShellFiles,
  libnitrokey,
  poetry-core,
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
  tqdm,
  tlv8,
  typing-extensions,
  click-aliases,
  semver,
  nethsm,
  importlib-metadata,
  nitrokey,
  pyscard,
  asn1crypto,
}:

let
  pname = "pynitrokey";
  version = "0.9.0";
  mainProgram = "nitropy";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sRyJuyBSJdl+8DJKvhXsy1i8OzHRA7OtNn3KCM+dxuc=";
  };

  disabled = pythonOlder "3.10";

  nativeBuildInputs = [ installShellFiles ];

  build-system = [ poetry-core ];

  dependencies = [
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
    tqdm
    tlv8
    typing-extensions
    click-aliases
    semver
    nethsm
    importlib-metadata
    nitrokey
    pyscard
    asn1crypto
  ];

  pythonRelaxDeps = true;

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
