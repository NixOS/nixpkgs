{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ebcdic";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "roskakori";
    repo = "CodecMapper";
    tag = "v${version}";
    hash = "sha256-gRyZychcF3wYocgVbdF255cSuZh/cl8X0WH/Iplkmxc=";
  };

  sourceRoot = "${src.name}/${pname}";

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/roskakori/CodecMapper/issues/18
    "test_can_lookup_ebcdic_codec"
    "test_can_recode_euro_sign"
    "test_has_codecs"
    "test_has_ignored_codec_names"
  ];

  pythonImportsCheck = [ "ebcdic" ];

  meta = with lib; {
    description = "Additional EBCDIC codecs";
    homepage = "https://github.com/roskakori/CodecMapper/tree/master/ebcdic";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
