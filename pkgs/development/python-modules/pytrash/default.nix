{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytrash";
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NSPC911";
    repo = "pytrash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a52iwyV8wMzkw9O2ga9vSCbXjqpshd89qTmJbOrOj9k=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.11.28,<0.12.0' 'uv_build>=0.11.28'
  '';

  build-system = [
    uv-build
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytrash" ];

  meta = {
    changelog = "https://github.com/NSPC911/pytrash/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/NSPC911/pytrash";
    description = "High level Cross-platform API for trash and recycle bin library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kangazero ];
  };
})
