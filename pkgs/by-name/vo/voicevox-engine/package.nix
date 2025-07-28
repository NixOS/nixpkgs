{
  lib,
  fetchFromGitHub,
  python3Packages,
  voicevox-core,
}:

python3Packages.buildPythonApplication rec {
  pname = "voicevox-engine";
  version = "0.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox_engine";
    tag = version;
    hash = "sha256-WoHTv4VjLFJPIi47WETMQM8JmgBctAWlue8yKmi1+6A=";
  };

  patches = [
    # this patch makes the package installable via hatchling
    ./make-installable.patch
  ];

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = [
    passthru.pyopenjtalk
  ]
  ++ (with python3Packages; [
    fastapi
    jinja2
    kanalizer
    numpy
    platformdirs
    pydantic
    python-multipart
    pyworld
    pyyaml
    semver
    setuptools
    soundfile
    soxr
    starlette
    uvicorn
  ]);

  pythonRemoveDeps = [
    # upstream wants fastapi-slim, but we provide fastapi instead
    "fastapi-slim"
  ];

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

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    syrupy
    httpx
  ];

  passthru = {
    resources = fetchFromGitHub {
      name = "voicevox-resource-${version}"; # this contains ${version} to invalidate the hash upon updating the package
      owner = "VOICEVOX";
      repo = "voicevox_resource";
      tag = version;
      hash = "sha256-4D9b5MjJQq+oCqSv8t7CILgFcotbNBH3m2F/up12pPE=";
    };

    pyopenjtalk = python3Packages.callPackage ./pyopenjtalk.nix { };
  };

  meta = {
    changelog = "https://github.com/VOICEVOX/voicevox_engine/releases/tag/${src.tag}";
    description = "Engine for the VOICEVOX speech synthesis software";
    homepage = "https://github.com/VOICEVOX/voicevox_engine";
    license = lib.licenses.lgpl3Only;
    mainProgram = "voicevox-engine";
    maintainers = with lib.maintainers; [
      tomasajt
      eljamm
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
