{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  odfdo,
  uv-build,
}:
buildPythonPackage (finalAttrs: {
  pname = "odsparsator";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdum";
    repo = "odsparsator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DpVWkspaZYYJHGYOrLte4JevH25xRzu38M2+QdFG22M=";
  };

  build-system = [ uv-build ];

  dependencies = [ odfdo ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.0,<0.10.0" "uv_build"
    substituteInPlace tests/test_cli.py \
      --replace-fail '"odsparsator"' "\"$out/bin/odsparsator\""
  '';

  meta = {
    description = "Generate a json file from an OpenDocument Format .ods file";
    homepage = "https://github.com/jdum/odsparsator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
