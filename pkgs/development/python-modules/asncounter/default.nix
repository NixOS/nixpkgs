{
  lib,
  fetchFromGitLab,
  buildPackages,
  installShellFiles,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  pyasn,
  manhole,
  netaddr,
  scapy,
  prometheus-client,
  pytestCheckHook,

  # Whether to enable all optional dependencies
  withFull ? true,
  enableManPages ? buildPackages.pandoc.compiler.bootstrapAvailable,
}:

buildPythonPackage rec {
  pname = "asncounter";
  version = "0.5.0";

  src = fetchFromGitLab {
    owner = "anarcat";
    repo = "asncounter";
    tag = version;
    hash = "sha256-aFnxPc1qLIBzN3fKaGhcqF4z1TIToeSONJd0VgaMchQ=";
  };

  pyproject = true;
  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = lib.optionals enableManPages [
    buildPackages.pandoc
    installShellFiles
  ];

  dependencies = [
    pyasn
  ]
  # TODO(@sternenseemann): switch could be per dependency…
  ++ lib.optionals withFull optional-dependencies.full;

  optional-dependencies.full = [
    manhole
    netaddr
    scapy
    prometheus-client
  ];

  # see debian/rules
  postInstall = lib.optionals enableManPages ''
    pandoc --standalone --to man asncounter.1.md > asncounter.1
    installManPage asncounter.1
  '';

  doCheck = true;
  checkInputs = optional-dependencies.full;
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Count the number of hits per autonomous system number (ASN) and related network blocks";
    homepage = "https://gitlab.com/anarcat/asncounter";
    changelog = "https://gitlab.com/anarcat/asncounter/-/blob/${version}/debian/changelog?ref_type=tags";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
