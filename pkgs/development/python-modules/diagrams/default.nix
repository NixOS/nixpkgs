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
  version = "0.20.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mingrammer";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lcqsy3bvlnlnakjysp8qjhy26bhkp1izi5dvzq2fpsffgxk4si4";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'jinja2 = "^2.10"' 'jinja2 = "*"'
  '';

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  patches = [ ./build_poetry.patch ];

  checkInputs = [ pytestCheckHook ];

  # Despite living in 'tool.poetry.dependencies',
  # these are only used at build time to process the image resource files
  nativeBuildInputs = [ black inkscape imagemagick jinja2 poetry-core round ];

  propagatedBuildInputs = [ graphviz ];

  meta = with lib; {
    description = "Diagram as Code";
    homepage    = "https://diagrams.mingrammer.com/";
    license     = licenses.mit;
    maintainers =  with maintainers; [ addict3d ];
  };
}
