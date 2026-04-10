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
  version = "1.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdum";
    repo = "odsparsator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f/xrIcERB+rPK27lG+R2Dfy0/Qemqgn9PIch7KE17gs=";
  };

  build-system = [ uv-build ];

  dependencies = [ odfdo ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
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
