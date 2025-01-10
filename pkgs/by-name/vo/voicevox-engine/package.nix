{
  lib,
  fetchFromGitHub,
  python3Packages,
  replaceVars,
  voicevox-core,
}:

python3Packages.buildPythonApplication rec {
  pname = "voicevox-engine";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox_engine";
    rev = "refs/tags/${version}";
    hash = "sha256-Gib5R7oleg+XXyu2V65EqrflQ1oiAR7a09a0MFhSITc=";
  };

  patches = [
    # the upstream package only uses poetry for dependency management, not for package definition
    # this patch makes the package installable via poetry-core
    (replaceVars ./make-installable.patch {
      inherit version;
    })
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies =
    [
      passthru.pyopenjtalk
    ]
    ++ (with python3Packages; [
      numpy
      fastapi
      jinja2
      python-multipart
      uvicorn
      soundfile
      pyyaml
      pyworld
      semver
      platformdirs
      soxr
      pydantic
      starlette
    ]);

  pythonRemoveDeps = [
    # upstream wants fastapi-slim, but we provide fastapi instead
    "fastapi-slim"
  ];

  pythonRelaxDeps = true;

  preConfigure = ''
    # copy demo metadata to temporary directory
    mv resources/character_info test_character_info

    # populate the `character_info` directory with the actual model metadata instead of the demo metadata
    cp -r --no-preserve=all ${passthru.resources}/character_info resources/character_info

    # the `character_info` directory copied from `resources` doesn't exactly have the expected format,
    # so we transform them to be acceptable by `voicevox-engine`
    pushd resources/character_info
    for dir in *; do
        # remove unused large files
        rm $dir/*/*.png_large

        # rename directory from "$name_$uuid" to "$uuid"
        mv $dir ''${dir#*"_"}
    done
    popd
  '';

  makeWrapperArgs = [
    ''--add-flags "--voicelib_dir=${voicevox-core}/lib"''
  ];

  preCheck = ''
    # some tests assume $HOME actually exists
    export HOME=$(mktemp -d)

    # since the actual metadata files have been installed to `$out` by this point,
    # we can move the demo metadata back to its place for the tests to succeed
    rm -r resources/character_info
    mv test_character_info resources/character_info
  '';

  disabledTests = [
    # this test checks the behaviour of openapi
    # one of the functions returns a slightly different output due to openapi version differences
    "test_OpenAPIの形が変わっていないことを確認"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    syrupy
    httpx
  ];

  passthru = {
    resources = fetchFromGitHub {
      owner = "VOICEVOX";
      repo = "voicevox_resource";
      rev = "refs/tags/${version}";
      hash = "sha256-m888DF9qgGbK30RSwNnAoT9D0tRJk6cD5QY72FRkatM=";
    };

    pyopenjtalk = python3Packages.callPackage ./pyopenjtalk.nix { };
  };

  meta = {
    changelog = "https://github.com/VOICEVOX/voicevox_engine/releases/tag/${version}";
    description = "Engine for the VOICEVOX speech synthesis software";
    homepage = "https://github.com/VOICEVOX/voicevox_engine";
    license = lib.licenses.lgpl3Only;
    mainProgram = "voicevox-engine";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
