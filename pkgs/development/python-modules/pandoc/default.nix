{ buildPythonPackage
, fetchFromGitHub
, lib
, plumbum
, ply
}:

buildPythonPackage rec {
  pname = "pandoc";
  version = "2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "boisgera";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-53LCxthxFGiUV5go268e/VOOtk/H5x1KazoRoYuu+Q0=";
  };

  propagatedBuildInputs = [
    plumbum
    ply
  ];

  pythonImportsCheck = [ "pandoc" ];

  # Non-standard test runner
  doCheck = false;

  meta = with lib; {
    description = "Library Pandoc's data model for markdown documents";
    homepage = "https://boisgera.github.io/pandoc/";
    changelog = "https://github.com/boisgera/pandoc/blob/v${version}/mkdocs/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jupblb ];
  };
}
