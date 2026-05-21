{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pbr,
  pytestCheckHook,

  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage (
  finalAttrs:
  let
    inherit (finalAttrs) version;
  in
  {
    pname = "git-url-parse";
    version = "1.2.2";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "coala";
      repo = "git-url-parse";
      tag = version;
      hash = "sha256-+0V/C3wE02ppdDGn7iqdvmgsUwTR7THUakUilvkzoYg=";
    };

    # Manually set version because prb wants to get it from the git
    # upstream repository (and we are installing from tarball instead)
    env.PBR_VERSION = version;

    build-system = [ setuptools ];

    dependencies = [ pbr ];

    pythonImportsCheck = [ "giturlparse" ];

    nativeCheckInputs = [
      pytestCheckHook
      pytest-cov-stub
    ];

    meta = {
      description = "Simple GIT URL parser";
      homepage = "https://github.com/coala/git-url-parse";
      changelog = "https://github.com/coala/git-url-parse/blob/${version}/CHANGELOG.rst";
      license = lib.licenses.mit;
      maintainers = [ ];
    };
  }
)
