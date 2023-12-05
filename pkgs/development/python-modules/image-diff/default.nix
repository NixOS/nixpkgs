{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, pillow
, click
, click-default-group
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "image-diff";
  version = "0.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "image-diff";
    rev = version;
    hash = "sha256-AQykJNvBgVjmPVTwJOX17eKWelqvZZieq/giid8GYAY=";
  };

  propagatedBuildInputs = [
    pillow
    click
    click-default-group
  ];

  pythonImportsCheck = [ "image_diff" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "CLI tool for comparing images";
    homepage = "https://github.com/simonw/image-diff";
    license = licenses.asl20;
    maintainers = with maintainers; [ evils ];
  };
}
