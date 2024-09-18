{
  lib,
  attrs,
  bidict,
  bitstruct,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  more-itertools,
  poetry-core,
  pprintpp,
  pythonOlder,
  tbm-utils,
}:

buildPythonPackage rec {
  pname = "audio-metadata";
  version = "0.11.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thebigmunch";
    repo = "audio-metadata";
    rev = "refs/tags/${version}";
    hash = "sha256-5ZX4HwbuB9ZmFfHuxaMCrn3R7/znuDsoyqqLql2Nizg=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/thebigmunch/audio-metadata/pull/41
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/thebigmunch/audio-metadata/commit/dfe91a69ee37e9dcefb692165eb0f9cd36a7e5b8.patch";
      hash = "sha256-ut3mqgZQu0YFbsTEA13Ch0+aSNl17ndMV0fuIu3n5tc=";
    })
  ];

  pythonRelaxDeps = [
    "attrs"
    "more-itertools"
  ];

  build-system = [ poetry-core ];


  dependencies = [
    attrs
    bidict
    bitstruct
    more-itertools
    pprintpp
    tbm-utils
  ];

  # Tests require ward which is not ready to be used
  doCheck = false;

  pythonImportsCheck = [ "audio_metadata" ];

  meta = with lib; {
    description = "Library for handling the metadata from audio files";
    homepage = "https://github.com/thebigmunch/audio-metadata";
    changelog = "https://github.com/thebigmunch/audio-metadata/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
