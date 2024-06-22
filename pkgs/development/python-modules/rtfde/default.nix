{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  lxml,
  oletools,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rtfde";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seamustuohy";
    repo = "RTFDE";
    rev = "refs/tags/${version}";
    hash = "sha256-ai9JQ3gphY/IievBNdHiblIpc0IPS9wp7CVvBIRzG/4=";
  };

  postPatch = ''
    # https://github.com/seamustuohy/RTFDE/issues/31
    substituteInPlace setup.py \
      --replace-fail "==" ">="
  '';

  build-system = [ setuptools ];

  dependencies = [
    lark
    oletools
  ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "RTFDE" ];

  meta = with lib; {
    description = "Library for extracting encapsulated HTML and plain text content from the RTF bodies";
    homepage = "https://github.com/seamustuohy/RTFDE";
    changelog = "https://github.com/seamustuohy/RTFDE/releases/tag/${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
