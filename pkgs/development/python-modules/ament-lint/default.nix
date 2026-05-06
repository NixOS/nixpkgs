{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-lint";
  version = "0.21.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ament";
    repo = "ament_lint";
    tag = finalAttrs.version;
    hash = "sha256-jarp7+SjaQAigrE9WQ+j6yEKxvkyfDwz+dyWEL6vGwo=";
  };

  sourceRoot = "${finalAttrs.src.name}/ament_lint";

  build-system = [ setuptools ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Providing common API for ament linter packages";
    homepage = "https://github.com/ament/ament_lint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
