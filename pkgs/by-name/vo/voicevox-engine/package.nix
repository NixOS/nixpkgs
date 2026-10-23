{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  voicevox-core,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "voicevox-engine";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox_engine";
    tag = finalAttrs.version;
    hash = "sha256-Paj6zx9/rkxZjrkc8jg0Fhuqe/nF+CADORU/udSxIj0=";
  };

  patches = [
    # this patch makes the package installable via hatchling
    ./make-installable.patch
  ];

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
      fastapi
      jinja2
      kanalizer
      numpy
      platformdirs
      pydantic
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pyhwloc ]
    ++ [
      finalAttrs.passthru.pyopenjtalk
      python-multipart
      pyworld
      pyyaml
      semver
      setuptools
      soundfile
      soxr
      starlette
      uvicorn
    ];

  # upstream has started pinning exact versions
  pythonRelaxDeps = true;

  preConfigure = ''
    # copy demo metadata to temporary directory
    mv resources/character_info test_character_info

    # populate the `character_info` directory with the actual model metadata instead of the demo metadata
    cp -r --no-preserve=all ${finalAttrs.passthru.resources}/character_info resources/character_info

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
    "--add-flag"
    "--voicelib_dir=${voicevox-core.wrapped}/lib"
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
    httpx2
  ];

  passthru = {
    resources = fetchFromGitHub {
      name = "voicevox-resource-${finalAttrs.version}"; # this contains ${version} to invalidate the hash upon updating the package
      owner = "VOICEVOX";
      repo = "voicevox_resource";
      tag = finalAttrs.version;
      hash = "sha256-1uw55PpYlM+srzc46Jfq8DPHTbbIv+HxX0LxQEMfRDY=";
    };

    pyopenjtalk = python3Packages.callPackage ./pyopenjtalk.nix { };
  };

  meta = {
    changelog = "https://github.com/VOICEVOX/voicevox_engine/releases/tag/${finalAttrs.src.tag}";
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
})
