{
  runCommand,
  python,
  yq,
}:
let
  venv = python.withPackages (ps: [
    ps.llm
    ps.llm-gemini
  ]);
in
runCommand "llm-gemini-test-llm-plugin"
  {
    nativeBuildInputs = [
      venv
      yq
    ];
  }
  ''
    llm plugins | yq --exit-status 'any(.name == "llm-gemini")'
    touch "$out"
  ''
