{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  filetype,
  mutagen,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mediafile";
  version = "0.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "mediafile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H7WVA5JF6bmKCLV0siGt8Jp+WE1q8z4aQrugOUW06K0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    filetype
    mutagen
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mediafile" ];

  meta = {
    description = "Python interface to the metadata tags for many audio file formats";
    homepage = "https://github.com/beetbox/mediafile";
    changelog = "https://github.com/beetbox/mediafile/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
})
