{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ebcdic";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roskakori";
    repo = "CodecMapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-71EMWUGoJrsc3EOVHeV4xqSJRKoA7Sz2dvmZJ1sjQCg=";
  };

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/roskakori/CodecMapper/issues/18
    "test_can_lookup_ebcdic_codec"
    "test_can_recode_euro_sign"
    "test_has_codecs"
    "test_has_ignored_codec_names"
  ];

  pythonImportsCheck = [ "ebcdic" ];

  meta = {
    description = "Additional EBCDIC codecs";
    homepage = "https://github.com/roskakori/CodecMapper/tree/master/ebcdic";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
