{
  lib,
  asciidoctor,
  automake,
  installShellFiles,
  python3,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      # https://github.com/sys4/tlsrpt-reporter/issues/43
      url = "https://github.com/sys4/tlsrpt-reporter/commit/32d00c13508dd7f9695b77e253e88c88dc838fbd.patch";
      hash = "sha256-RUNF86RkTu6DLv6/7eaY//fFB8kGzmZxQ70kdNpLxj8=";
    })
    # https://github.com/sys4/tlsrpt-reporter/pull/48
    ./logging.patch
  ];

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
