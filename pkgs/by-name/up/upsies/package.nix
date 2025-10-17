{
  lib,
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
  version = "2025.10.09";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "plotski";
    repo = "upsies";
    tag = "v${version}";
    hash = "sha256-mFGeN1ic0jTuamKG1QK30rz5OklwEN5Gykk93IOvUco=";
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

  disabledTestPaths = [
    # DNS resolution errors in the sandbox on some of the tests
    "tests/utils_test/http_test/http_test.py"
    "tests/utils_test/http_test/http_tls_test.py"
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

  meta = with lib; {
    description = "Toolkit for collecting, generating, normalizing and sharing video metadata";
    homepage = "https://upsies.readthedocs.io/";
    license = licenses.gpl3Plus;
    mainProgram = "upsies";
    maintainers = with maintainers; [ ambroisie ];
  };
}
