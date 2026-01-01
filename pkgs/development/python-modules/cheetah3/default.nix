{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "cheetah3";
<<<<<<< HEAD
  version = "3.4.0.post5";
=======
  version = "3.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CheetahTemplate3";
    repo = "cheetah3";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-qWV6ncSe4JbGZD7sLc/kEXY1pUM1II24UgsS/zX872Y=";
=======
    hash = "sha256-yIdswcCuoDR3R/Subl22fKB55pgw/sDkrPy+vwNgaxI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  doCheck = false; # Circular dependency

  pythonImportsCheck = [ "Cheetah" ];

<<<<<<< HEAD
  meta = {
    description = "Template engine and code generation tool";
    homepage = "http://www.cheetahtemplate.org/";
    changelog = "https://github.com/CheetahTemplate3/cheetah3/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pjjw ];
=======
  meta = with lib; {
    description = "Template engine and code generation tool";
    homepage = "http://www.cheetahtemplate.org/";
    changelog = "https://github.com/CheetahTemplate3/cheetah3/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pjjw ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
