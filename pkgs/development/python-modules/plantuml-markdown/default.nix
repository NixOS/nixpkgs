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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "plantuml-markdown";
  version = "3.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mikitex70";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5+l3JkK/8S1KFXqa0++l3mIQ2KCpHe9+DiVqasBAZA0=";
  };

  propagatedBuildInputs = [
    plantuml
    markdown
    requests
    six
  ];

  # The package uses a custom script that downloads a certain version of plantuml for testing.
  doCheck = false;

  pythonImportsCheck = [
    "plantuml_markdown"
  ];

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
    changelog = "https://github.com/mikitex70/plantuml-markdown/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nikstur ];
  };
}
