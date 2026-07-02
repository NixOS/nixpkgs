{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  cryptography,
  nibabel,
  numpy,
  pydicom,
  simpleitk,
}:

buildPythonPackage rec {
  pname = "pymedio";
  version = "0.2.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jcreinhold";
    repo = "pymedio";
    tag = "v${version}";
    hash = "sha256-x3CHoWASDrUoCXfj73NF+0Y/3Mb31dK2Lh+o4OD9ryk=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    cryptography
    nibabel
    pydicom
    simpleitk
  ];

  pythonImportsCheck = [ "pymedio" ];

  meta = {
    description = "Read medical image files into Numpy arrays";
    homepage = "https://github.com/jcreinhold/pymedio";
    changelog = "https://github.com/jcreinhold/pymedio/blob/v${version}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
