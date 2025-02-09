{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, jinja2
, poetry-core
, round
, graphviz
, inkscape
, imagemagick
, pytestCheckHook
, typed-ast
}:

buildPythonPackage rec {
  pname = "diagrams";
  version = "0.23.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2jRWN2glGEr51fzny8nkqa5c2EdJG5aZPG2eTD7AISY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'graphviz = ">=0.13.2,<0.20.0"' 'graphviz = "*"'
  '';

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  patches = [
    # The build-system section is missing
    ./build_poetry.patch
    ./remove-black-requirement.patch
  ];

  # Despite living in 'tool.poetry.dependencies',
  # these are only used at build time to process the image resource files
  nativeBuildInputs = [
    inkscape imagemagick
    jinja2
    poetry-core
    round
  ];

  propagatedBuildInputs = [
    graphviz
    typed-ast
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "diagrams"
  ];

  meta = with lib; {
    description = "Diagram as Code";
    homepage = "https://diagrams.mingrammer.com/";
    changelog = "https://github.com/mingrammer/diagrams/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ addict3d ];
  };
}
