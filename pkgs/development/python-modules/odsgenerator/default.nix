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
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdum";
    repo = "odsgenerator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+EwjZG2hSXBVApjrGdd1Pja/w6ny15Vqud2nya+ei5g=";
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
