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
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "baseplate-admin";
    repo = "resvg-py";
    tag = finalAttrs.version;
    hash = "sha256-SRY22I4wK3v8RrwkS3/5YjBe+IRLnUS/KYYThDUByXY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-5gyzo48SEct7kaN9ckectoHsuS1EJcJOdT+dxpKw+QQ=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytest
    pyperclip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
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
