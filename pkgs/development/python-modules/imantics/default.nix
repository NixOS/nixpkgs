{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  numpy,
  opencv-python,
  lxml,
  xmljson,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "imantics";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsbroks";
    repo = "imantics";
    rev = "76d81036d8f92854d63ad9938dd76c718f8b482e";
    sha256 = "1zv2gj8cbakhh2fyr2611cbqhfk37a56x973ny9n43y70n26pzm8";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    opencv-python
    lxml
    xmljson
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "imantics" ];

<<<<<<< HEAD
  meta = {
    description = "Convert and visualize many annotation formats for object dectection and localization";
    homepage = "https://github.com/jsbroks/imantics";
    license = with lib.licenses; [ mit ];
    maintainers = [ lib.maintainers.rakesh4g ];
=======
  meta = with lib; {
    description = "Convert and visualize many annotation formats for object dectection and localization";
    homepage = "https://github.com/jsbroks/imantics";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.rakesh4g ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
