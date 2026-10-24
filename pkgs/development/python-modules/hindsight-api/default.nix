{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  runCommand,
  setuptools,
  hindsight-api-slim,
}:

buildPythonPackage (finalAttrs: {
  pname = "hindsight-api";
  version = "0.8.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vectorize-io";
    repo = "hindsight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w6diZVKzRaRxrr0G3EOqA2nAl4r5VkQfepUZz8b7YJ8="; # same tag as slim
  };
  sourceRoot = "${finalAttrs.src.name}/hindsight-api";

  build-system = [ setuptools ];

  # Slim is wired in without the [all] extras (not packaged); rewrite the
  # requirement to drop the extras marker and the ==0.8.4 pin
  # (pythonRelaxDeps can't strip [all], hence substituteInPlace).
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'hindsight-api-slim[all]==0.8.4' 'hindsight-api-slim'
  '';

  dependencies = [ hindsight-api-slim ];

  doCheck = false;

  passthru.tests = {
    import-test = finalAttrs.finalPackage.overrideAttrs {
      doCheck = true;
      pythonImportsCheck = [ "hindsight_api" ];
    };
    cli-help =
      runCommand "${finalAttrs.pname}-cli-help-test"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          hindsight-api --help
          touch $out
        '';
  };

  meta = {
    description = "Semantic agent memory API server";
    homepage = "https://github.com/vectorize-io/hindsight";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gdifolco ];
    mainProgram = "hindsight-api";
  };
})
