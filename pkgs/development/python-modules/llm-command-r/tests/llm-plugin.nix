{
  runCommand,
  python,
  yq,
}:
let
  venv = python.withPackages (ps: [
    ps.llm
    ps.llm-anthropic
  ]);
in
runCommand "llm-anthropic-test-llm-plugin"
  {
    nativeBuildInputs = [
      venv
      yq
    ];
  }
  ''
    llm plugins | yq --exit-status 'any(.name == "llm-anthropic")'
    touch "$out"
  ''
