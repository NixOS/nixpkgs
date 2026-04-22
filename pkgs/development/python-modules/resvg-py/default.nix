{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytest,
  pyperclip,
  xvfb-run,
  xclip,
}:

buildPythonPackage (finalAttrs: {
  pname = "resvg-py";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "baseplate-admin";
    repo = "resvg-py";
    tag = finalAttrs.version;
    hash = "sha256-YWu05lYHKWnofnfP6TDvc1yJV5GPwDKJ87twbvKW+Ak=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-9v3GtXeeKMw49SCYlTVBvyECNr8gw+D/hVHQWOoUDHc=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytest
    pyperclip
  ]
  ++ lib.optionals stdenv.isLinux [
    xclip
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck
    ${lib.optionalString stdenv.hostPlatform.isLinux "xvfb-run"} python -m pytest ${lib.optionalString stdenv.hostPlatform.isDarwin "-k \"not test_multiple_layer_svg\""}
    runHook postCheck
  '';

  pythonImportsCheck = [
    "resvg_py"
  ];

  meta = {
    changelog = "https://github.com/baseplate-admin/resvg-py/releases/tag/${finalAttrs.src.tag}";
    description = "High level wrapper of resvg for python";
    homepage = "https://github.com/baseplate-admin/resvg-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
