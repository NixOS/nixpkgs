{ lib
, buildPythonApplication
, fetchFromGitHub
, pdfminer-six
, setuptools
, wheel
}:

buildPythonApplication rec {
  pname = "pdftitle";
  version = "0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metebalci";
    repo = "pdftitle";
    rev = "v${version}";
    hash = "sha256-kj1pJpyWRgEaAADF6YqzdD8QnJ6iu0eXFMR4NGM4/+Y=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    pdfminer-six
  ];

  pythonImportsCheck = [ "pdftitle" ];

  meta = with lib; {
    description = "A utility to extract the title from a PDF file";
    homepage = "https://github.com/metebalci/pdftitle";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dansbandit ];
    mainProgram = "pdftitle";
  };
}
