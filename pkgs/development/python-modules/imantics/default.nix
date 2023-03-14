{ buildPythonPackage
, fetchFromGitHub
, lib
, numpy
, opencv3
, sphinx-rtd-theme
, lxml
, xmljson
}:

buildPythonPackage rec {
  pname = "imantics";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "jsbroks";
    repo = "imantics";
    rev = "76d81036d8f92854d63ad9938dd76c718f8b482e";
    sha256 = "1zv2gj8cbakhh2fyr2611cbqhfk37a56x973ny9n43y70n26pzm8";
  };

  propagatedBuildInputs = [
    numpy
    opencv3
    sphinx-rtd-theme
    lxml
    xmljson
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'opencv-python>=3'," ""
  '';

  # failing on NixOS
  doCheck = false;

  pythonImportsCheck = [ "imantics" ];

  meta = with lib; {
    description = "Convert and visualize many annotation formats for object dectection and localization";
    homepage = "https://github.com/jsbroks/imantics";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.rakesh4g ];
  };
}
