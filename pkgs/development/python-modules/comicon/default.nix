{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "1.3.0";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "comicon";
    tag = "v${version}";
    hash = "sha256-0AGCTnStyBVL7DVkrUFyD60xnuuO1dcl+Twdyy+uq1Y=";
  };

  patches = [
    # Upstream forgot to bump the version before tagging
    # See https://github.com/potatoeggy/comicon/commit/d698f0f03b1a391f988176885686e9fca135676e
    (fetchpatch2 {
      name = "comicon-version-bump.patch";
      url = "https://github.com/potatoeggy/comicon/commit/d698f0f03b1a391f988176885686e9fca135676e.diff";
      hash = "sha256-ZHltw4OSYuHF8mH0kBZDsuozPy08Bm7nme+XSwfGNn8=";
    })
  ];

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
