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
  version = "1.2.0";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "comicon";
    rev = "refs/tags/v${version}";
    hash = "sha256-oiEzZRgyG/RQCo2zSTqwlOhkwz76lSImR0ZtSlIUp4Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "pillow"
    "pypdf"
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
