{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pbr,
  setuptools,
  installShellFiles,

  # direct
  python-keystoneclient,

  # tests
  stestrCheckHook,
  versionCheckHook,
  hacking,
  coverage,
  keystoneauth1,
  stestr,
  openstacksdk,

  # docs
  sphinxHook,
  openstackdocstheme,
  sphinxcontrib-apidoc,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-swiftclient";
  version = "4.10.0";
  pyproject = true;

  build-system = [
    pbr
    setuptools
  ];

  env.PBR_VERSION = finalAttrs.version;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-swiftclient";
    tag = finalAttrs.version;
    hash = "sha256-G3o9R3+hDQgvSnmle0paZo/KV56OMU38tIXqUJGmUaQ=";
  };

  nativeBuildInputs = [
    openstackdocstheme
    sphinxcontrib-apidoc
    sphinxHook
    installShellFiles
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    python-keystoneclient
  ];

  nativeCheckInputs = [
    stestrCheckHook
    openstacksdk
    hacking
    coverage
    keystoneauth1
    stestr
    openstacksdk
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = ''
    installShellCompletion --cmd swift --bash tools/swift.bash_completion
    installManPage doc/manpages/*
  '';

  pythonImportsCheck = [
    "swiftclient"
  ];

  meta = {
    description = "Client library for OpenStack Swift API";
    mainProgram = "swift";
    homepage = "https://docs.openstack.org/python-swiftclient/latest/";
    downloadPage = "https://github.com/openstack/python-swiftclient/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
