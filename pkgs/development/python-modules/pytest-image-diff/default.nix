{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  typing-extensions,
  diffimg,
  imgdiff,
  pytestCheckHook,
  recommonmark,
}:

buildPythonPackage rec {
  pname = "pytest-image-diff";
  version = "0.0.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Apkawa";
    repo = "pytest-image-diff";
    tag = "v${version}";
    hash = "sha256-BQwEbZBgjnx5becu5dcDx0yiw3Y2qptwyqywFq6lqas=";
  };

  propagatedBuildInputs = [
    typing-extensions
    diffimg
    imgdiff
  ];

  pythonImportsCheck = [ "pytest_image_diff" ];

  nativeCheckInputs = [
    pytestCheckHook
    recommonmark
  ];

  meta = with lib; {
    description = "Pytest helps for compare images and regression";
    homepage = "https://github.com/Apkawa/pytest-image-diff";
    license = licenses.mit;
    maintainers = [ ];
  };
}
