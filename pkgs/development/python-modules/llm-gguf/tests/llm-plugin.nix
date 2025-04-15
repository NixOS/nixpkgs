{
  runCommand,
  python,
  yq,
}:
let
  venv = python.withPackages (ps: [
    ps.llm
    ps.llm-gguf
  ]);
in
runCommand "llm-gguf-test-llm-plugin"
  {
    nativeBuildInputs = [
      venv
      yq
    ];
  }
  ''
    llm plugins | yq --exit-status 'any(.name == "llm-gguf")'
    touch "$out"
  ''
