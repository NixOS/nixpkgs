{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  writeScript,
  writeShellScriptBin,
  gradio,

  # build-system
  hatchling,
  hatch-requirements-txt,
  hatch-fancy-pypi-readme,

  # web assets
  zip,
  nodejs_24,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,

  # dependencies
  aiofiles,
  anyio,
  audioop-lts,
  brotli,
  fastapi,
  ffmpy,
  gradio-client,
  groovy,
  httpx,
  huggingface-hub,
  jinja2,
  markupsafe,
  numpy,
  orjson,
  packaging,
  pandas,
  pillow,
  pydantic,
  python-multipart,
  pydub,
  pyyaml,
  safehttpx,
  semantic-version,
  starlette,
  tomlkit,
  typer,
  typing-extensions,
  uvicorn,

  # oauth
  authlib,
  itsdangerous,

  # tests
  pytestCheckHook,
  hypothesis,
  altair,
  boto3,
  diffusers,
  docker,
  gradio-pdf,
  ffmpeg,
  ipython,
  mcp,
  polars,
  pytest-asyncio,
  respx,
  scikit-image,
  torch,
  tqdm,
  transformers,
  vega-datasets,
  writableTmpDirAsHomeHook,
}:
let
  nodejs = nodejs_24;
  pnpm = pnpm_10.override { inherit nodejs; };
in
buildPythonPackage rec {
  pname = "gradio";
  version = "6.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gradio-app";
    repo = "gradio";
    tag = "gradio@${version}";
    hash = "sha256-pIcliKcb1eVVMk0ARzWcZGXc6pmI8mGVAvCJZ0JHXUw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      pnpm
      version
      src
      ;
    fetcherVersion = 3;
    hash = "sha256-6Cx0hdVd0srhArvck2Kn9U2fT7aKtTZjgV5b/Usrnoo=";
  };

  pythonRelaxDeps = [
    "aiofiles"
    "gradio-client"
    "markupsafe"
    "pydantic" # Requests >=2.11.10,<=2.12.4. Staging has it, master doesn't.
  ];

  pythonRemoveDeps = [
    # this isn't a real runtime dependency
    "ruff"
  ];

  nativeBuildInputs = [
    zip
    nodejs
    pnpm
    pnpmConfigHook
    writableTmpDirAsHomeHook
  ];

  build-system = [
    hatchling
    hatch-requirements-txt
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    aiofiles
    anyio
    brotli
    fastapi
    ffmpy
    gradio-client
    groovy
    httpx
    huggingface-hub
    jinja2
    markupsafe
    numpy
    orjson
    packaging
    pandas
    pillow
    pydantic
    python-multipart
    pydub
    pyyaml
    safehttpx
    semantic-version
    starlette
    tomlkit
    typer
    typing-extensions
    uvicorn
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    audioop-lts
  ];

  optional-dependencies.oauth = [
    authlib
    itsdangerous
  ];

  nativeCheckInputs = [
    altair
    boto3
    brotli
    diffusers
    docker
    ffmpeg
    gradio-pdf
    hypothesis
    ipython
    mcp
    polars
    pytest-asyncio
    pytestCheckHook
    respx
    # shap is needed as well, but breaks too often
    scikit-image
    torch
    tqdm
    transformers
    vega-datasets

    # mock calls to `shutil.which(...)`
    (writeShellScriptBin "npm" "false")
  ]
  ++ optional-dependencies.oauth
  ++ pydantic.optional-dependencies.email;

  preBuild = ''
    pnpm build
    pnpm package
  '';

  # Add a pytest hook skipping tests that access network, marking them as "Expected fail" (xfail).
  # We additionally xfail FileNotFoundError, since the gradio devs often fail to upload test assets to pypi.
  preCheck = ''
    cat ${./conftest-skip-network-errors.py} >> test/conftest.py
  ''
  # OSError: [Errno 24] Too many open files
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    ulimit -n 4096
  '';

  disabledTests = [
    # Actually broken
    "test_mount_gradio_app"
    "test_processing_utils_backwards_compatibility" # type error

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
    "test_encode_url_to_base64_doesnt_encode_errors"

    # flaky: OSError: Cannot find empty port in range: 7860-7959
    "test_docs_url"
    "test_orjson_serialization"
    "test_dataset_is_updated"
    "test_multimodal_api"
    "test_examples_keep_all_suffixes"
    "test_progress_bar"
    "test_progress_bar_track_tqdm"
    "test_info_and_warning_alerts"
    "test_info_isolation[True]"
    "test_info_isolation[False]"
    "test_examples_no_cache_optional_inputs"
    "test_start_server[127.0.0.1]"
    "test_start_server[[::1]]"
    "test_single_request"
    "test_all_status_messages"
    "test_default_concurrency_limits[not_set-statuses0]"
    "test_default_concurrency_limits[None-statuses1]"
    "test_default_concurrency_limits[1-statuses2]"
    "test_default_concurrency_limits[2-statuses3]"
    "test_concurrency_limits"

    # tests if pip and other tools are installed
    "test_get_executable_path"

    # Flaky test (AssertionError when comparing to a fixed array)
    # https://github.com/gradio-app/gradio/issues/11620
    "test_auto_datatype"

    # Failed: DID NOT RAISE <class 'ValueError'>
    # (because it raises our NixNetworkAccessDeniedError)
    "test_private_request_fail"

    # TypeError: argument should be a str or an os.PathLike object where __fspath__ returns a str, not 'NoneType'
    "test_component_example_values"
    "test_public_request_pass"
    "test_theme_builder_launches"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky on darwin (depend on port availability)
    "test_all_status_messages"
    "test_analytics_summary"
    "test_async_generators"
    "test_async_generators_interface"
    "test_async_iterator_update_with_new_component"
    "test_blocks_close_closes_thread_properly"
    "test_caching"
    "test_caching_audio_with_progress"
    "test_caching_image"
    "test_caching_with_async_generators"
    "test_caching_with_batch"
    "test_caching_with_batch_multiple_outputs"
    "test_caching_with_dict"
    "test_caching_with_float_numbers"
    "test_caching_with_generators"
    "test_caching_with_generators_and_streamed_output"
    "test_caching_with_mix_update"
    "test_caching_with_non_io_component"
    "test_caching_with_update"
    "test_chat_interface_api_name"
    "test_chat_interface_api_names_with_additional_inputs"
    "test_component_returned"
    "test_css_and_css_paths_parameters"
    "test_custom_css"
    "test_default_concurrency_limits"
    "test_default_flagging_callback"
    "test_end_to_end"
    "test_end_to_end_cache_examples"
    "test_event_data"
    "test_every_does_not_block_queue"
    "test_example_caching"
    "test_example_caching_async"
    "test_example_caching_relaunch"
    "test_example_caching_with_additional_inputs"
    "test_example_caching_with_additional_inputs_already_rendered"
    "test_example_caching_with_streaming"
    "test_example_caching_with_streaming_async"
    "test_exit_called_at_launch"
    "test_file_component_uploads"
    "test_files_saved_as_file_paths"
    "test_flagging_does_not_create_unnecessary_directories"
    "test_flagging_no_permission_error_with_flagging_disabled"
    "test_info_and_warning_alerts"
    "test_info_isolation"
    "test_launch_analytics_does_not_error_with_invalid_blocks"
    "test_mcp_streamable_http_client"
    "test_mcp_streamable_http_client_with_progress_callback"
    "test_multiple_file_flagging"
    "test_multiple_messages"
    "test_no_empty_audio_files"
    "test_no_empty_image_files"
    "test_no_empty_video_files"
    "test_non_streaming_api"
    "test_non_streaming_api_async"
    "test_no_postprocessing"
    "test_no_preprocessing"
    "test_pil_images_hashed"
    "test_post_process_file_blocked"
    "test_progress_bar"
    "test_progress_bar_track_tqdm"
    "test_queue_when_using_auth"
    "test_restart_after_close"
    "test_set_share_in_colab"
    "test_setting_cache_dir_env_variable"
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
    "test_use_default_theme_as_fallback"
    "test_varying_output_forms_with_generators"
  ];

  disabledTestPaths = [
    # 100% touches network
    "test/test_networking.py"
    "client/python/test/test_client.py"
    # makes pytest freeze 50% of the time
    "test/test_interfaces.py"

    # Local network tests dependant on port availability (port 7860-7959)
    "test/test_routes.py"

    # No module named build.__main__; 'build' is a package and cannot be directly executed
    "test/test_docker/test_reverse_proxy/test_reverse_proxy.py"
    "test/test_docker/test_reverse_proxy_fastapi_mount/test_reverse_proxy_fastapi_mount.py"
    "test/test_docker/test_reverse_proxy_root_path/test_reverse_proxy_root_path.py"
  ];

  disabledTestMarks = [
    "flaky"
  ];

  pytestFlags = [
    "-x" # abort on first failure
    # "-Wignore" # uncomment for debugging help
    # Requires writable media assets in /nix/store
    "--deselect"
    "test/components/test_video.py::TestVideo::test_component_functions"
  ];

  # check the binary works outside the build env
  postCheck = ''
    env --ignore-environment $out/bin/gradio environment >/dev/null
  '';

  pythonImportsCheck = [ "gradio" ];

  # Cyclic dependencies are fun!
  # This is gradio without gradio-client and gradio-pdf
  passthru = {
    sans-reverse-dependencies =
      (gradio.override {
        gradio-client = null;
        gradio-pdf = null;
      }).overridePythonAttrs
        (old: {
          pname = old.pname + "-sans-reverse-dependencies";
          pythonRemoveDeps = (old.pythonRemoveDeps or [ ]) ++ [ "gradio-client" ];
          doInstallCheck = false;
          doCheck = false;
          postPatch = "";
          preCheck = "";
          disabledTests = [ ];
          disabledTestPaths = [ ];
          disabledTestMarks = [ ];
          pytestFlags = [ ];
          postInstall = ''
            shopt -s globstar
            for f in $out/**/*.py; do
              cp $f "$f"i
            done
            shopt -u globstar
          '';
          pythonImportsCheck = null;
          dontCheckRuntimeDeps = true;
        });

    # We can't use gitUpdater, because we need to update the pnpm hash.
    # And we can't just use nix-update-script, because it often does not fetch
    # enough tags for the ones we're looking for to show up.
    updateScript = writeScript "update-python3Packages.gradio" ''
      #! /usr/bin/env nix-shell
      #! nix-shell -i bash -p common-updater-scripts coreutils gnugrep gnused nix-update

      tag=$(list-git-tags \
            | grep "^gradio@" \
            | sed -e "s,^gradio@,," \
            | grep -v -E -e ".*-(beta|dev).*" \
            | sort --reverse --version-sort \
            | head -n 1 \
            | tr -d '\n' \
           )
      nix-update --version="$tag"
    '';
  };

  meta = {
    homepage = "https://www.gradio.app/";
    changelog = "https://github.com/gradio-app/gradio/releases/tag/gradio@${version}";
    description = "Python library for easily interacting with trained machine learning models";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
