{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonRelaxDepsHook,
  pythonOlder,
  ebooklib,
  lxml,
  pillow,
  pypdf,
  python-slugify,
}:

buildPythonPackage rec {
  pname = "comicon";
  version = "1.1.0";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "comicon";
    rev = "v${version}";
    hash = "sha256-VP4n2pWXHge2gJ67O2nErJ30gI0vaAMn0VOpX8sLkfs=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "pypdf" ];

  propagatedBuildInputs = [
    ebooklib
    lxml
    pillow
    pypdf
    python-slugify
  ];

  pythonImportsCheck = [ "comicon" ];

  meta = with lib; {
    changelog = "https://github.com/potatoeggy/comicon/releases/tag/v${version}";
    description = "Lightweight comic converter library between CBZ, PDF, and EPUB";
    homepage = "https://github.com/potatoeggy/comicon";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
