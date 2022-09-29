{ buildPythonPackage
, fetchFromGitHub
, lib
, plantuml
, markdown
, requests
, six
, runCommand
, writeText
, plantuml-markdown
}:
let
  pname = "plantuml-markdown";
  version = "3.6.3";
in
buildPythonPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "mikitex70";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-y5Z7mjx2+DW8DwSSyy3tLn11rB7daQyyjsoY/QoI6mc=";
  };

  propagatedBuildInputs = [
    plantuml
    markdown
    requests
    six
  ];

  # The package uses a custom script that downloads a certain version of plantuml for testing.
  doCheck = false;

  pythonImportsCheck = [ "plantuml_markdown" ];

  passthru.tests.example-doc =
    let
      exampleDoc = writeText "plantuml-markdown-example-doc.md" ''
        ```plantuml
          Bob -> Alice: Hello
        ```
      '';
    in
    runCommand "plantuml-markdown-example-doc"
      {
        nativeBuildInputs = [ plantuml-markdown ];
      } ''
      markdown_py -x plantuml_markdown ${exampleDoc} > $out

      ! grep -q "Error" $out
    '';

  meta = with lib; {
    description = "PlantUML plugin for Python-Markdown";
    longDescription = ''
      This plugin implements a block extension which can be used to specify a PlantUML
      diagram which will be converted into an image and inserted in the document.
    '';
    homepage = "https://github.com/mikitex70/plantuml-markdown";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nikstur ];
  };
}
