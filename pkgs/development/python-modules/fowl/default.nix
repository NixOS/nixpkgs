{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  twisted,
  attrs,
  click,
  rich,
  humanize,
  magic-wormhole,
  msgpack,
  six,
  pytestCheckHook,
  pytest-twisted,
}:
buildPythonPackage rec {
  pname = "fowl";
  version = "25.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meejah";
    repo = "fowl";
    tag = version;
    hash = "sha256-HWe7/2Kem4rinFFqM8rlUh35w2VDhHwoPWypz/klyN0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    attrs
    click
    humanize
    magic-wormhole
    magic-wormhole.optional-dependencies.dilation
    msgpack
    rich
    six
    twisted
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-twisted
  ];

  # TODO Enable
  doCheck = false;

  # ipaddress is part of Python stdlib since 3.3
  pythonRemoveDeps = [ "ipaddress" ];

  pythonImportsCheck = [ "fowl" ];

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/fowl --help | grep Usage
    runHook postInstallCheck
  '';

  meta = {
    description = "Forward over Wormhole: stream connections over magic-wormhole Dilation connections";
    homepage = "https://github.com/meejah/fowl";
    license = lib.licenses.mit;
    mainProgram = "fowl";
    maintainers = with lib.maintainers; [ yajo ];
  };
}
