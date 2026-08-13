{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  odfdo,
  pyyaml,
  uv-build,
}:
buildPythonPackage (finalAttrs: {
  pname = "odsgenerator";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdum";
    repo = "odsgenerator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FfwyqNI5Hz2Muoe/VWgQigea6D042UoRbXDV9GNV4w4=";
  };

  build-system = [ uv-build ];

  dependencies = [
    odfdo
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.0,<0.10.0" "uv_build"
    substituteInPlace tests/test_cli.py \
      --replace-fail '"odsgenerator"' "\"$out/bin/odsgenerator\""
  '';

  meta = {
    description = "odsgenerator generates an ODF .ods file from json or yaml file";
    homepage = "https://github.com/jdum/odsgenerator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
