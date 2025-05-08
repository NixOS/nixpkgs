{
  runCommand,
  python,
  yq,
}:
let
  venv = python.withPackages (ps: [
    ps.llm
    ps.llm-fragments-github
  ]);
in
runCommand "llm-fragments-github-test-llm-plugin"
  {
    nativeBuildInputs = [
      venv
      yq
    ];
  }
  ''
    llm plugins | yq --exit-status 'any(.name == "llm-fragments-github")'
    touch "$out"
  ''
