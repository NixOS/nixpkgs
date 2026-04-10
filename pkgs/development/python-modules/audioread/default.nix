{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  standard-aifc,
  standard-sunau,
  ffmpeg-headless,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "audioread";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sampsyo";
    repo = "audioread";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QvgwjUGuzeHH69YAdZdImjMT+9t4YxAukbuZKk0lBro=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    standard-aifc
    standard-sunau
  ];

  nativeCheckInputs = [
    ffmpeg-headless
    pytestCheckHook
  ];

  meta = {
    description = "Cross-platform audio decoding";
    homepage = "https://github.com/sampsyo/audioread";
    license = lib.licenses.mit;
  };
})
