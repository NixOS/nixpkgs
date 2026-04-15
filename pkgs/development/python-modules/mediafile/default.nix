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
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "mediafile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GKEm2LKR3F9uy3FdhvpLPE9Auca8+40Zp53yaLk45XE=";
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
