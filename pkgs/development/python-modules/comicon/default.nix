{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  ebooklib,
  lxml,
  pillow,
  pypdf,
  python-slugify,
}:

buildPythonPackage rec {
  pname = "comicon";
  version = "1.4.0";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "comicon";
    tag = "v${version}";
    hash = "sha256-jZ/ZhSFg0ZPTYI10s8Cn1s9UZRFFnuLjS96lnUFVekQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "pillow"
  ];

  propagatedBuildInputs = [
    ebooklib
    lxml
    pillow
    pypdf
    python-slugify
  ];

  doCheck = false; # test artifacts are not public

  pythonImportsCheck = [ "comicon" ];

  meta = with lib; {
    changelog = "https://github.com/potatoeggy/comicon/releases/tag/v${version}";
    description = "Lightweight comic converter library between CBZ, PDF, and EPUB";
    homepage = "https://github.com/potatoeggy/comicon";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
