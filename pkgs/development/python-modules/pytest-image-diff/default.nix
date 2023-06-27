{ lib
, python3
, buildPythonPackage
, fetchFromGitHub
, typing-extensions
, diffimg
, imgdiff
, pytestCheckHook
, recommonmark
}:

buildPythonPackage rec {
  pname = "pytest-image-diff";
  version = "0.0.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Apkawa";
    repo = "pytest-image-diff";
    rev = "v${version}";
    hash = "sha256-7GBwxm0YQNN/Gq1yyBIxCEYbM7hmOFa9kUsfbBKQtBQ=";
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
    maintainers = with maintainers; [ evils ];
  };
}
