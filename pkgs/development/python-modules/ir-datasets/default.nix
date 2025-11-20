{
  lib,
  # Build system
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  # Dependencies
  beautifulsoup4,
  ijson,
  inscriptis,
  lxml,
  lz4,
  numpy,
  pyarrow,
  pyyaml,
  requests,
  tqdm,
  trec-car-tools,
  unlzw3,
  warc3-wet,
  warc3-wet-clueweb,
  zlib-state,
}:
buildPythonPackage rec {
  pname = "ir-datasets";
  version = "0.5.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenai";
    repo = "ir_datasets";
    rev = "v${version}";
    hash = "sha256-9RNTs6WiwmFc7LG2LGZuRxUMLHw2RePELCZx/7IF5cQ=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    beautifulsoup4
    ijson
    inscriptis
    lxml
    lz4
    numpy
    pyarrow
    pyyaml
    requests
    tqdm
    trec-car-tools
    unlzw3
    warc3-wet
    warc3-wet-clueweb
    zlib-state
  ];

  meta = {
    description = "Provides a common interface to many IR ranking datasets";
    homepage = "https://github.com/allenai/ir_datasets";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gurjaka ];
    mainProgram = "ir-datasets";
  };
}
