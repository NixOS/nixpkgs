{
  lib,
  stdenv,
  apple-sdk_15,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyoxigraph";
  version = "0.5.11";
  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K32b8C5+2Jywy89sN2rvNh8cPJ3kmnqPs6wjFUS7a6g=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-2+GTh77DDlCJGWRWUPZhSgD5l5VPu/N3JJ/4FaNUpUc=";
  };

  buildAndTestSubdir = "python";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  pythonImportsCheck = [ "pyoxigraph" ];

  enabledTestPaths = [ "python/tests" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_update_load" ];

  meta = {
    description = "SPARQL graph database";
    homepage = "https://github.com/oxigraph/oxigraph";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dadada ];
    platforms = lib.platforms.unix;
  };
}
