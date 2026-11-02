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
      cacert
      venv
      writableTmpDirAsHomeHook
      yq
    ];
  }
  ''
    llm plugins | yq --exit-status 'any(.name == "${plugin.pname}")'
    touch "$out"
  ''
