{
  cacert,
  runCommand,
  writableTmpDirAsHomeHook,
  yq,
  llm,
  plugin,
}:
let
  venv = llm.pythonModule.withPackages (_: [
    llm
    plugin
  ]);
in
runCommand "${plugin.pname}-test"
  {
    nativeBuildInputs = [
      venv
      writableTmpDirAsHomeHook
      yq
    ];
    env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  }
  ''
    llm plugins | yq --exit-status 'any(.name == "${plugin.pname}")'
    touch "$out"
  ''
