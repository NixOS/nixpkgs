{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  numpy,
  opencv4,
  lxml,
  xmljson,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "imantics";
  version = "0.1.12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jsbroks";
    repo = "imantics";
    rev = "76d81036d8f92854d63ad9938dd76c718f8b482e";
    sha256 = "1zv2gj8cbakhh2fyr2611cbqhfk37a56x973ny9n43y70n26pzm8";
  };

  propagatedBuildInputs = [
    numpy
    opencv4
    lxml
    xmljson
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'opencv-python>=3'," ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "imantics" ];

  meta = with lib; {
    description = "Convert and visualize many annotation formats for object dectection and localization";
    homepage = "https://github.com/jsbroks/imantics";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.rakesh4g ];
  };
}
