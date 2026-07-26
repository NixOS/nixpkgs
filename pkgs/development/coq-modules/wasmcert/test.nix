{
  stdenv,
  coq,
  wasmcert,
}:

stdenv.mkDerivation {
  pname = "wasmcert-interpreter-test";
  inherit (wasmcert) src version;
  nativeCheckInputs = [
    wasmcert
    coq
  ];
  dontConfigure = true;
  dontBuild = true;
  doCheck = true;

  checkPhase = ''
    coqc .ci/import_test.v

    wasm_coq_interpreter tests/add.wasm -r main

    if [ $? -ne 0 ]; then
      echo "Wasm_coq_interpreter failed to run hello world program"
      exit 1
    fi
  '';

  installPhase = "touch $out";
}
