{
  lib,
  asciidoctor,
  automake,
  installShellFiles,
  python3,
  fetchFromGitHub,
  nixosTests,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tlsrpt-reporter";
  version = "0.5.0";
  pyproject = true;

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "sys4";
    repo = "tlsrpt-reporter";
    tag = "v${version}";
    hash = "sha256-IH8hJX9l+YonqOuszcMome4mjdIaedgGNIptxTyH1ng=";
  };

  nativeBuildInputs = [
    asciidoctor
    automake
    installShellFiles
  ];

  build-system = [
    python3.pkgs.hatchling
  ];

  postBuild = ''
    make -C doc
  '';

  postInstall = ''
    installManPage doc/*.1
  '';

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
  ];

  pythonImportsCheck = [
    "tlsrpt_reporter"
  ];

  passthru.tests = {
    inherit (nixosTests) tlsrpt;
  };

  meta = {
    description = "Application suite to receive TLSRPT datagrams and to generate and deliver TLSRPT reports";
    homepage = "https://github.com/sys4/tlsrpt-reporter";
    changelog = "https://github.com/sys4/tlsrpt-reporter/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
