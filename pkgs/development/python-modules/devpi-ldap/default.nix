{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  devpi-server,
  ldap3,
  pyyaml,

  # tests
  packaging-legacy,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  webtest,
}:

buildPythonPackage (finalAttrs: {
  pname = "devpi-ldap";
  version = "2.1.1-unstable-2026-05-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi-ldap";
    rev = "542db8a84ca4ee066b47c5266595b7a33b0d8a05";
    hash = "sha256-T1POtNownu2xlGFI0Jz/Ki19GmW1P7R75/8AM3br/kE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_changelog_shortener",' ""
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    devpi-server
    ldap3
    pyyaml
  ];

  nativeCheckInputs = [
    packaging-legacy
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    webtest
  ];

  pythonImportsCheck = [ "devpi_ldap" ];

  passthru.skipBulkUpdate = true; # avoid reversion to previous stable version

  meta = {
    description = "LDAP authentication for devpi-server";
    homepage = "https://github.com/devpi/devpi-ldap";
    changelog = "https://github.com/devpi/devpi-ldap/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ confus ];
  };
})
