{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonRelaxDepsHook
, ebooklib
, lxml
, pillow
, pypdf
}:

buildPythonPackage rec {
  pname = "comicon";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "comicon";
    rev = "v${version}";
    hash = "sha256-e9YEr8IwttMlj6FOxk+/kw79qiF1N8/e2qusfw3WH00=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "lxml"
    "pillow"
  ];

  propagatedBuildInputs = [
    ebooklib
    lxml
    pillow
    pypdf
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
