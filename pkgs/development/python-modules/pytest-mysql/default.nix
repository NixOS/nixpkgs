{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  mirakuru,
  port-for,
  pymysql,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-mysql";
  version = "5.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dbfixtures";
    repo = "pytest-mysql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XmRu8lz2pIhOEsNT0DhD1Vypne1DkFL02KiVEsYb6Vk=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    mirakuru
    port-for
    pymysql
  ];

  # There seems to be no mysqlTestHook yet
  doCheck = false;
  pythonRemoveDeps = [ "pytest" ];

  pythonImportsCheck = [
    "pytest_mysql"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "This is a pytest plugin, that enables you to test your code that relies on a running MySQL Database. It allows you to specify fixtures for MySQL process and client";
    homepage = "https://github.com/dbfixtures/pytest-mysql";
    changelog = "https://github.com/dbfixtures/pytest-mysql/blob/${finalAttrs.src.rev}/CHANGES.rst";
    license = with lib.licenses; [
      # Project also contains a GPL3 file, but doesn't mention it in any source files
      lgpl3Plus
    ];
    maintainers = [ ];
  };
})
