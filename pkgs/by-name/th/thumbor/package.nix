{
  lib,
  fetchFromGitHub,
  python3,
  gifsicle,
  libjpeg,
  ffmpeg,
  nixosTests,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "thumbor";
  version = "7.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thumbor";
    repo = "thumbor";
    tag = version;
    hash = "sha256-ZuZmI1mvfQn3hkDa5qgfEguuXmPK8t5rJH9vnR95sHY=";

    # Fix fetch on Darwin. See https://github.com/thumbor/thumbor/pull/1754
    # TODO: remove this once Thumbor version is > 7.7.7 and reenable associated tests
    postFetch = ''
      rm $out/tests/fixtures/images/alabama1_ap620*.jpg
    '';
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  # Thumbor depends on `remotecv` for queued detection, however `remotecv`
  # depends on `pyres` which has been removed from nixpkgs because it’s
  # abandoned. The package still works fine without `remotecv` as long as
  # queued detection is not configured.
  dependencies = with python3.pkgs; [
    colorama
    derpconf
    jpegiptc
    libthumbor
    piexif
    pillow
    pillow-avif-plugin
    pillow-heif
    pycurl
    pytz
    opencv-python-headless
    statsd
    thumbor-plugins-gifv
    tornado
    webcolors
  ];

  optional-dependencies = {
    svg = [ python3.pkgs.cairosvg ];
  };

  pythonRelaxDeps = [
    "pillow"
    "pytz"
    "setuptools"
    "webcolors"
  ];

  buildInputs = [
    libjpeg
    ffmpeg
  ];

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
    gifsicle
    libjpeg
    ffmpeg
  ];

  checkInputs = with python3.pkgs; [
    cairosvg
    preggy
    pyssim
    pytest-asyncio
    sentry-sdk
    redis
  ];

  preCheck = ''
    # Cleaning up the thumbor directory is necessary to avoid errors with
    # Python extension modules
    find thumbor -type f -name '*.py' -delete
  '';

  disabledTestPaths = [
    # Depends on remotecv which in turn depends on pyres, which is abandoned
    "tests/detectors/test_queued_detector.py"
  ];

  disabledTests = [
    # Checks existence of /bin/ls
    "test_can_which_by_path"
    # Error probably due to the mock object not matching the object in the Sentry SDK version in nixpkgs
    "test_when_error_occurs_should_have_called_client"
    # Not sure how this test is supposed to pass
    "test_watermark_filter_detect_extension_simple"

    # TODO: enable all these tests once Thumbor version is > 7.7.7
    "test_modifying_existing_image_to_small_image"
    "test_utf8_encoded_image_name_with_encoded_url"
    "test_meta_with_unicode"
    "test_image_already_generated_by_thumbor_2_times"
    "test_can_post_from_html_form"
    "test_can_post_image_with_charset"
    "test_can_post_image_with_content_type"
    "test_can_post_image_with_unknown_charset"
    "test_can_post_image_without_filename"
    "test_can_modify_existing_image"
    "test_can_get_actual_id_when_stored_with_large_id"
    "test_cant_get_truncated_id_when_stored_with_large_id"
    "test_can_delete_existing_image"
    "test_can_retrieve_existing_image"
    "test_modifying_existing_image_to_heavy_image_fails"
    "test_modifying_existing_image_to_invalid_image"
  ];

  pythonImportsCheck = [
    "thumbor"
  ];

  passthru.tests = {
    inherit (nixosTests) thumbor;
  };

  meta = {
    description = "Open-source photo thumbnail service by globo.com";
    homepage = "https://github.com/thumbor/thumbor/";
    changelog = "https://github.com/thumbor/thumbor/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sephi ];
    mainProgram = "thumbor";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
