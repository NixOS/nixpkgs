{
  lib,
  stdenv,
  fetchFromGitea,
  fetchpatch,
  ffmpeg-headless,
  mediainfo,
  oxipng,
  python3Packages,
}:
let
  # Taken from `docker/alpine/Dockerfile`
  runtimeDeps = [
    ffmpeg-headless
    mediainfo
    oxipng
  ];
in
python3Packages.buildPythonApplication rec {
  pname = "upsies";
  version = "2025.12.22";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "plotski";
    repo = "upsies";
    tag = "v${version}";
    hash = "sha256-wVQleIpPZHlb4FFyteaEvHu6M3WuuOXZ0ChqqlABJsQ=";
  };

  patches = [
    (fetchpatch {
      name = "use-pytest-timeout.patch";
      url = "https://codeberg.org/plotski/upsies/commit/db6b564f8575c913a6fbabb61d5326a073c9b52c.patch";
      hash = "sha256-UeUrZ6ogUSS0FvyNQwwwp8q+FArEK61o+Y2Uh7mrPtw=";
      revert = true;
    })
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aiobtclientapi
    async-lru
    beautifulsoup4
    countryguess
    guessit
    httpx
    langcodes
    natsort
    packaging
    prompt-toolkit
    pydantic
    pyimgbox
    pyparsebluray
    pyxdg
    term-image
    torf
    unidecode
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytest-asyncio
      pytest-cov-stub
      pytest-httpserver
      pytest-mock
      pytest-timeout
      pytestCheckHook
      trustme
    ]
    ++ runtimeDeps;

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fail during object comparisons on Darwin
    "test_group"
    "test_has_commentary"
    "test_special_case"
    "test_set_release_info"
    "test_Query_from_release"
    # Depend on directory format
    "test_home_directory_property"
    # Depends on specific cocdecs not available on Darwin
    "test_generate_episode_queries"
    # Assert false == true
    "test_is_mixed_scene_release"
    # Fails due to expecting a non-darwin path format
    "test_search"
  ];

  disabledTestPaths = [
    # DNS resolution errors in the sandbox on some of the tests
    "tests/utils_test/http_test/http_test.py"
    "tests/utils_test/http_test/http_tls_test.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fail due to the different set of codecs on Darwin
    "tests/utils_test/predbs_test/predbs_integration_test.py"
    "tests/utils_test/release_info_test.py"
  ];

  preCheck = ''
    # `utils.is_running_in_development_environment` expects it in tests
    export VIRTUAL_ENV=1
  '';

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath runtimeDeps)
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Toolkit for collecting, generating, normalizing and sharing video metadata";
    homepage = "https://upsies.readthedocs.io/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "upsies";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
