{
  buildPythonPackage,
  fetchFromGitHub,
  pkgs, # Only for pkgs.plantuml,
  lib,
  plantuml,
  markdown,
  requests,
  six,
  runCommand,
  writeText,
  plantuml-markdown,
}:

buildPythonPackage rec {
  pname = "plantuml-markdown";
  version = "3.11.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mikitex70";
    repo = "plantuml-markdown";
    tag = version;
    hash = "sha256-DgHWqwPsZ5q1XqrfaAiUslKnJdHX4Pzw9lygF3iaxz4=";
  };

  postPatch = ''
    substituteInPlace plantuml_markdown/plantuml_markdown.py \
      --replace-fail '"plantuml_cmd": ["plantuml"' '"plantuml_cmd": ["${lib.getExe pkgs.plantuml}"'
  '';

  propagatedBuildInputs = [
    plantuml
    markdown
    requests
    six
  ];

  # The package uses a custom script that downloads a certain version of plantuml for testing.
  # Missing https://github.com/ezequielramos/http-server-mock which looks unmaintained
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
    runCommand "plantuml-markdown-example-doc" { nativeBuildInputs = [ plantuml-markdown ]; } ''
      markdown_py -x plantuml_markdown ${exampleDoc} > $out

      ! grep -q "Error" $out
    '';

  meta = {
    description = "PlantUML plugin for Python-Markdown";
    longDescription = ''
      This plugin implements a block extension which can be used to specify a PlantUML
      diagram which will be converted into an image and inserted in the document.
    '';
    homepage = "https://github.com/mikitex70/plantuml-markdown";
    changelog = "https://github.com/mikitex70/plantuml-markdown/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nikstur ];
  };
}
