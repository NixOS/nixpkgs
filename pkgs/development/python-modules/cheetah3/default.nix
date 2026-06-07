{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cheetah3";
  version = "3.4.0.post5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CheetahTemplate3";
    repo = "cheetah3";
    tag = version;
    hash = "sha256-qWV6ncSe4JbGZD7sLc/kEXY1pUM1II24UgsS/zX872Y=";
  };

  build-system = [ setuptools ];

  doCheck = false; # Circular dependency

  pythonImportsCheck = [ "Cheetah" ];

  meta = {
    description = "Template engine and code generation tool";
    homepage = "http://www.cheetahtemplate.org/";
    changelog = "https://github.com/CheetahTemplate3/cheetah3/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pjjw ];
  };
}
