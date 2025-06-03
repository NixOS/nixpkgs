{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cheetah3";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CheetahTemplate3";
    repo = "cheetah3";
    tag = version;
    hash = "sha256-yIdswcCuoDR3R/Subl22fKB55pgw/sDkrPy+vwNgaxI=";
  };

  doCheck = false; # Circular dependency

  pythonImportsCheck = [ "Cheetah" ];

  meta = with lib; {
    description = "Template engine and code generation tool";
    homepage = "http://www.cheetahtemplate.org/";
    changelog = "https://github.com/CheetahTemplate3/cheetah3/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pjjw ];
  };
}
