{
  buildPythonPackage,
  lib,
  prototools,
  stdenv,

  # build-system
  setuptools,

  # dependencies
  click,
  fdp-scan,
  protobuf,

  # nativeBuildInputs
  installShellFiles,

  # tests
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "protoscan";
  inherit (prototools) version;
  pyproject = true;
  __structuredAttrs = true;

  inherit (prototools) src;

  sourceRoot = "${prototools.src.name}/protoscan";

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    fdp-scan
    protobuf
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/protoscan/tests/" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd protoscan \
      --bash <(_PROTOSCAN_COMPLETE=bash_source $out/bin/protoscan) \
      --zsh  <(_PROTOSCAN_COMPLETE=zsh_source  $out/bin/protoscan) \
      --fish <(_PROTOSCAN_COMPLETE=fish_source $out/bin/protoscan)
    # protoscan-gen-man calls mkdir(parents=True) internally; no mkdir needed.
    # SOURCE_DATE_EPOCH and LC_ALL ensure reproducible man page output.
    SOURCE_DATE_EPOCH=0 LC_ALL=C $out/bin/protoscan-gen-man $out/share/man/man1
  '';

  pythonImportsCheck = [ "protoscan" ];

  meta = {
    description = "Scan binary files for embedded protobuf FileDescriptorProto blobs";
    homepage = "https://github.com/ThalesGroup/prototools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "protoscan";
    platforms = lib.platforms.unix;
  };
}
