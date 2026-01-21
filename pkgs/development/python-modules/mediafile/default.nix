{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  filetype,
  mutagen,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mediafile";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "mediafile";
    tag = "v${version}";
    hash = "sha256-D5LRGncdeGcmJkrHVvI2cevov4SFO0wuhLxMqP+Ryb8=";
  };

  build-system = [ flit-core ];

  dependencies = [
    filetype
    mutagen
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mediafile" ];

  meta = {
    description = "Python interface to the metadata tags for many audio file formats";
    homepage = "https://github.com/beetbox/mediafile";
    changelog = "https://github.com/beetbox/mediafile/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lovesegfault ];
  };
}
