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
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "mediafile";
    tag = "v${version}";
    hash = "sha256-Knp91nVPFkE2qYSZoWcOsMBNY+OBfWCPPNn+T1L8v0o=";
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
