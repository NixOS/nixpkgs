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
    # the package uses poetry for dependency management, but not package definition
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

  pythonRemoveDeps = [ "fastapi-slim" ];

  # populate character_info directory with the actual model metadata instead of the demo metadata
  preConfigure = ''
    mv resources/character_info test_character_info
    cp -r --no-preserve=all ${passthru.resources}/character_info resources/character_info

    pushd resources/character_info
    for dir in *; do
        rm $dir/*/*.png_large
        mv $dir ''${dir#*"_"}
    done
    popd
  '';

  makeWrapperArgs = [ ''--add-flags "--voicelib_dir=${voicevox-core}/lib"'' ];

  preCheck = ''
    export HOME=$(mktemp -d)

    rm -r resources/character_info
    mv test_character_info resources/character_info
  '';

  disabledTests = [
    # this test checks the behaviour of openapi
    # a function returns slightly different output due to openapi version differences
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
