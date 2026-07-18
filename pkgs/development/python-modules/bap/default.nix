{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  bap,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "bap";
  version = "1.3.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-python";
    tag = finalAttrs.version;
    hash = "sha256-d9HST4AF5Jxycfbv/033GAtcU+Moqxf03VHhY1nNE6o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bap
    requests
  ];

  doCheck = false;

  meta = {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages";
    homepage = "https://github.com/BinaryAnalysisPlatform/bap/";
    maintainers = [ lib.maintainers.maurer ];
    license = lib.licenses.mit;
  };
})
