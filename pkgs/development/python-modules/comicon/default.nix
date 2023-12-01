{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, ebooklib
, lxml
, pillow
, pypdf
}:

buildPythonPackage rec {
  pname = "comicon";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "potatoeggy";
    repo = "comicon";
    rev = "v${version}";
    hash = "sha256-D6nK+GlcG/XqMTH7h7mJcbZCRG2xDHRsnooSTtphDNs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    ebooklib
    lxml
    pillow
    pypdf
  ];

  pythonImportsCheck = [ "comicon" ];

  meta = with lib; {
    description = "Lightweight comic converter library between CBZ, PDF, and EPUB";
    homepage = "https://github.com/potatoeggy/comicon";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
