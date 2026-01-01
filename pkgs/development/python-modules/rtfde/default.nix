{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  lxml,
  oletools,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "rtfde";
<<<<<<< HEAD
  version = "0.1.2.2";
  pyproject = true;

=======
  version = "0.1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "seamustuohy";
    repo = "RTFDE";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-1yjxp6N07I9kwFRtgsLo9UPSG4FU+ic1tNm6U/xWk74=";
=======
    hash = "sha256-dtPWgtOYpGaNRmIE7WNGJd/GWB2hQXsFJDDSHIcIjY4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "lark" ];

  dependencies = [
    lark
    oletools
  ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "RTFDE" ];

  disabledTests = [
    # Malformed encapsulated RTF discovered
    "test_encoded_bytes_stay_encoded_character"
  ];

  meta = {
    changelog = "https://github.com/seamustuohy/RTFDE/releases/tag/${src.tag}";
    description = "Library for extracting encapsulated HTML and plain text content from the RTF bodies";
    homepage = "https://github.com/seamustuohy/RTFDE";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
