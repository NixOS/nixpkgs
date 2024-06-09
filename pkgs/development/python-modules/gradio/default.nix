{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pythonRelaxDepsHook,
  writeShellScriptBin,
  gradio,

  # pyproject
  hatchling,
  hatch-requirements-txt,
  hatch-fancy-pypi-readme,

  # runtime
  setuptools,
  aiofiles,
  altair,
  diffusers,
  fastapi,
  ffmpy,
  gradio-client,
  httpx,
  huggingface-hub,
  importlib-resources,
  jinja2,
  markupsafe,
  matplotlib,
  numpy,
  orjson,
  packaging,
  pandas,
  pillow,
  pydantic,
  python-multipart,
  pydub,
  pyyaml,
  semantic-version,
  typing-extensions,
  uvicorn,
  typer,
  tomlkit,

  # oauth
  authlib,
  itsdangerous,

  # check
  pytestCheckHook,
  boto3,
  gradio-pdf,
  ffmpeg,
  ipython,
  pytest-asyncio,
  respx,
  scikit-image,
  torch,
  tqdm,
  transformers,
  vega-datasets,
}:

buildPythonPackage rec {
  pname = "gradio";
  version = "4.36.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  # We use the Pypi release, since it provides prebuilt webui assets
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gcHwR9eiou6HKBI4ab06+5CtOa3OtfdvB/sPL35dt2w=";
  };

  # fix packaging.ParserSyntaxError, which can't handle comments
  postPatch = ''
    sed -ie "s/ #.*$//g" requirements*.txt

    # they bundle deps?
    rm -rf venv/
  '';

  pythonRelaxDeps = [ "tomlkit" ];

  pythonRemoveDeps = [
    # our package is presented as a binary, not a python lib - and
    # this isn't a real runtime dependency
    "ruff"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    hatchling
    hatch-requirements-txt
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    setuptools # needed for 'pkg_resources'
    aiofiles
    altair
    diffusers
    fastapi
    ffmpy
    gradio-client
    httpx
    huggingface-hub
    importlib-resources
    jinja2
    markupsafe
    matplotlib
    numpy
    orjson
    packaging
    pandas
    pillow
    pydantic
    python-multipart
    pydub
    pyyaml
    semantic-version
    typing-extensions
    uvicorn
    typer
    tomlkit
  ] ++ typer.passthru.optional-dependencies.all;

  passthru.optional-dependencies.oauth = [
    authlib
    itsdangerous
  ];

  nativeCheckInputs = [
    pytestCheckHook
    boto3
    gradio-pdf
    ffmpeg
    ipython
    pytest-asyncio
    respx
    scikit-image
    # shap is needed as well, but breaks too often
    torch
    tqdm
    transformers
    vega-datasets

    # mock calls to `shutil.which(...)`
    (writeShellScriptBin "npm" "false")
  ] ++ passthru.optional-dependencies.oauth ++ pydantic.passthru.optional-dependencies.email;

  # Add a pytest hook skipping tests that access network, marking them as "Expected fail" (xfail).
  # We additionally xfail FileNotFoundError, since the gradio devs often fail to upload test assets to pypi.
  preCheck =
    ''
      export HOME=$TMPDIR
      cat ${./conftest-skip-network-errors.py} >> test/conftest.py
    ''
    + lib.optionalString stdenv.isDarwin ''
      # OSError: [Errno 24] Too many open files
      ulimit -n 4096
    '';

  disabledTests = [
    # Actually broken
    "test_mount_gradio_app"

    # requires network, it caught our xfail exception
    "test_error_analytics_successful"

    # Flaky, tries to pin dependency behaviour. Sensitive to dep versions
    # These error only affect downstream use of the check dependencies.
    "test_no_color"
    "test_in_interface_as_output"
    "test_should_warn_url_not_having_version"

    # Flaky, unknown reason
    "test_in_interface"

    # shap is too often broken in nixpkgs
    "test_shapley_text"

    # fails without network
    "test_download_if_url_correct_parse"

    # tests if pip and other tools are installed
    "test_get_executable_path"
  ] ++ lib.optionals stdenv.isDarwin [
    # flaky on darwin (depend on port availability)
    "test_all_status_messages"
    "test_async_generators"
    "test_async_generators_interface"
    "test_async_iterator_update_with_new_component"
    "test_concurrency_limits"
    "test_default_concurrency_limits"
    "test_default_flagging_callback"
    "test_end_to_end"
    "test_end_to_end_cache_examples"
    "test_event_data"
    "test_every_does_not_block_queue"
    "test_example_caching_relaunch"
    "test_example_caching_relaunch"
    "test_exit_called_at_launch"
    "test_file_component_uploads"
    "test_files_saved_as_file_paths"
    "test_flagging_does_not_create_unnecessary_directories"
    "test_flagging_no_permission_error_with_flagging_disabled"
    "test_info_and_warning_alerts"
    "test_info_isolation"
    "test_launch_analytics_does_not_error_with_invalid_blocks"
    "test_no_empty_audio_files"
    "test_no_empty_image_files"
    "test_no_empty_video_files"
    "test_non_streaming_api"
    "test_non_streaming_api_async"
    "test_pil_images_hashed"
    "test_progress_bar"
    "test_progress_bar_track_tqdm"
    "test_queue_when_using_auth"
    "test_restart_after_close"
    "test_set_share_in_colab"
    "test_show_error"
    "test_simple_csv_flagging_callback"
    "test_single_request"
    "test_socket_reuse"
    "test_start_server"
    "test_state_holder_is_used_in_postprocess"
    "test_state_stored_up_to_capacity"
    "test_static_files_single_app"
    "test_streaming_api"
    "test_streaming_api_async"
    "test_streaming_api_with_additional_inputs"
    "test_sync_generators"
    "test_time_to_live_and_delete_callback_for_state"
    "test_updates_stored_up_to_capacity"
    "test_varying_output_forms_with_generators"
  ];
  disabledTestPaths = [
    # 100% touches network
    "test/test_networking.py"
    # makes pytest freeze 50% of the time
    "test/test_interfaces.py"
  ] ++ lib.optionals stdenv.isDarwin [
    # Network-related tests that are flaky on darwin (depend on port availability)
    "test/test_routes.py"
  ];
  pytestFlagsArray = [
    "-x" # abort on first failure
    "-m 'not flaky'"
    #"-W" "ignore" # uncomment for debugging help
  ];

  # check the binary works outside the build env
  doInstallCheck = true;
  postInstallCheck = ''
    env --ignore-environment $out/bin/gradio environment >/dev/null
  '';

  pythonImportsCheck = [ "gradio" ];

  # Cyclic dependencies are fun!
  # This is gradio without gradio-client and gradio-pdf
  passthru.sans-reverse-dependencies =
    (gradio.override (old: {
      gradio-client = null;
      gradio-pdf = null;
    })).overridePythonAttrs
      (old: {
        pname = old.pname + "-sans-reverse-dependencies";
        pythonRemoveDeps = (old.pythonRemoveDeps or [ ]) ++ [ "gradio-client" ];
        doInstallCheck = false;
        doCheck = false;
        pythonImportsCheck = null;
        dontCheckRuntimeDeps = true;
      });

  meta = with lib; {
    homepage = "https://www.gradio.app/";
    description = "Python library for easily interacting with trained machine learning models";
    license = licenses.asl20;
    maintainers = with maintainers; [ pbsds ];
  };
}
