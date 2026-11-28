{
  lib,
  aws-lc,
  buildPythonPackage,
  cargo,
  fetchPypi,
  functiontrace-server,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
}:

buildPythonPackage rec {
  pname = "functiontrace";
  version = "0.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eXttNuy0z+q1K9Pt7nkkJyEcnOC5y2UgYau/KE+uxpU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-MpsQkMNY9VllBeA/FVPYJAqizmY6GWFtnb6O5tTO3/g=";
  };

  build-system = [
    setuptools
    setuptools-rust
  ];

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [ aws-lc ];

  pythonImportsCheck = [ "functiontrace" ];

  # `functiontrace` needs `functiontrace-server` in its path.
  # Technically we also need this when running via a Python import, such as for
  # `python3 -m functiontrace`, but that's a less common use-case.
  postFixup = ''
    wrapProgram $out/bin/functiontrace \
      --prefix PATH : ${lib.makeBinPath [ functiontrace-server ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://functiontrace.com";
    description = "Python module for Functiontrace";
    license = lib.licenses.prosperity30;
    maintainers = with lib.maintainers; [
      mathiassven
      tehmatt
    ];
  };
}
