{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tweetxvault";
  version = "0.2.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lhl";
    repo = "tweetxvault";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YLWVGdggJn8ZyiDCZsNPVhal2+8UL0B8GbdYL8IxFO0=";
  };

  # lancedb >= 0.40 treats null vectors as bad by default; rows are written
  # with a null `embedding` until embeddings are generated.
  postPatch = ''
    substituteInPlace tweetxvault/storage/backend.py \
      --replace-fail '.execute(payload)' '.execute(payload, on_bad_vectors="null")'
  '';

  build-system = [ python3Packages.hatchling ];

  pythonRelaxDeps = [
    "platformdirs"
    "rich"
    "pyarrow"
    "huggingface-hub"
  ];

  dependencies = with python3Packages; [
    browser-cookie3
    httpx
    lancedb
    loguru
    numpy
    platformdirs
    pyarrow
    pydantic
    rich
    tqdm
    typer
  ];

  optional-dependencies = {
    embed = with python3Packages; [
      huggingface-hub
      onnxruntime
      tokenizers
    ];
  };

  nativeCheckInputs =
    with python3Packages;
    [
      versionCheckHook
      pytestCheckHook
      pytest-asyncio
    ]
    ++ finalAttrs.passthru.optional-dependencies.embed;

  disabledTests = [
    # rich wraps --help output at 80 columns, splitting the asserted phrase
    "test_import_x_archive_help_describes_sample_limit"
  ];

  pythonImportsCheck = [ "tweetxvault" ];

  meta = {
    description = "Archive X (Twitter) bookmarks, likes, authored tweets, and official X exports locally";
    homepage = "https://github.com/lhl/tweetxvault";
    changelog = "https://github.com/lhl/tweetxvault/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "tweetxvault";
    maintainers = with lib.maintainers; [ io12 ];
  };
})
