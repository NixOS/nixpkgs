{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, black
, jinja2
, poetry-core
, round
, graphviz
, inkscape
, imagemagick
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "diagrams";
  version = "0.21.1";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YoXV5ikkBCSVyGmzEqp+7JLy82d7z9sbwS+U/EN3BFk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'jinja2 = "^2.10"' 'jinja2 = "*"' \
      --replace 'graphviz = ">=0.13.2,<0.17.0"' 'graphviz = "*"'
  '';

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  patches = [
    # The build-system section is missing
    ./build_poetry.patch
  ];

  checkInputs = [ pytestCheckHook ];

  # Despite living in 'tool.poetry.dependencies',
  # these are only used at build time to process the image resource files
  nativeBuildInputs = [ black inkscape imagemagick jinja2 poetry-core round ];

  propagatedBuildInputs = [ graphviz ];

  pythonImportsCheck = [ "diagrams" ];

  meta = with lib; {
    description = "Diagram as Code";
    homepage    = "https://diagrams.mingrammer.com/";
    license     = licenses.mit;
    maintainers =  with maintainers; [ addict3d ];
  };
}
