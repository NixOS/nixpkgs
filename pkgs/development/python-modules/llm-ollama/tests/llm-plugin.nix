{
  runCommand,
  python,
  yq,
  cacert,
}:
let
  venv = python.withPackages (ps: [
    ps.llm
    ps.llm-ollama
  ]);
in
runCommand "llm-ollama-test-llm-plugin"
  {
    nativeBuildInputs = [
      venv
      yq
    ];
    env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  }
  ''
    llm plugins | yq --exit-status 'any(.name == "llm-ollama")'
    touch "$out"
  ''
