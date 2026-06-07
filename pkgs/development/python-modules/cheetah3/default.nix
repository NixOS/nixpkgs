{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "cheetah3";
  version = "3.4.0.post5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CheetahTemplate3";
    repo = "cheetah3";
    tag = finalAttrs.version;
    hash = "sha256-qWV6ncSe4JbGZD7sLc/kEXY1pUM1II24UgsS/zX872Y=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "Cheetah" ];

  meta = {
    description = "Template engine and code generation tool";
    homepage = "https://www.cheetahtemplate.org/";
    changelog = "https://github.com/CheetahTemplate3/cheetah3/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pjjw ];
  };
})
