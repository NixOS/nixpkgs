{ lib
, python3Packages
, fetchFromGitHub
, fetchpatch
, installShellFiles
, git
, spdx-license-list-data
, substituteAll
}:


with python3Packages; buildPythonApplication rec {
  pname = "platformio";
  version = "6.1.15";
  pyproject = true;

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    hash = "sha256-w5JUAqQRNxq8ZrX8ffny2K7xWBkGr2H3+apYqCPXw9c=";
  };

  outputs = [ "out" "udev" ];

  patches = [
    (substituteAll {
      src = ./interpreter.patch;
      interpreter = (python3Packages.python.withPackages (_: propagatedBuildInputs)).interpreter;
    })
    (substituteAll {
      src = ./use-local-spdx-license-list.patch;
      spdx_license_list_data = spdx-license-list-data.json;
    })
    ./missing-udev-rules-nixos.patch
    (fetchpatch {
      # restore PYTHONPATH when calling scons
      # https://github.com/platformio/platformio-core/commit/097de2be98af533578671baa903a3ae825d90b94
      url = "https://github.com/platformio/platformio-core/commit/097de2be98af533578671baa903a3ae825d90b94.patch";
      hash = "sha256-yq+/QHCkhAkFND11MbKFiiWT3oF1cHhgWj5JkYjwuY0=";
      revert = true;
    })
  ];

  postPatch = ''
    # Disable update checks at runtime
    substituteInPlace platformio/maintenance.py --replace-fail '    check_platformio_upgrade()' ""

    # Remove filterwarnings which fails on new deprecations in Python 3.12 for 3.14
    rm tox.ini
  '';

  nativeBuildInputs = [
    installShellFiles
    setuptools
  ];

  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    aiofiles
    ajsonrpc
    bottle
    click
    click-completion
    colorama
    git
    lockfile
    marshmallow
    pyelftools
    pyserial
    requests
    semantic-version
    setuptools
    spdx-license-list-data.json
    starlette
    tabulate
    uvicorn
    wsproto
    zeroconf
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    chardet
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$PATH:$out/bin
  '';

  nativeCheckInputs = [
    jsondiff
    pytestCheckHook
  ];

  # Install udev rules into a separate output so all of platformio-core is not a dependency if
  # you want to use the udev rules on NixOS but not install platformio in your system packages.
  postInstall = ''
    mkdir -p $udev/lib/udev/rules.d
    cp platformio/assets/system/99-platformio-udev.rules $udev/lib/udev/rules.d/99-platformio-udev.rules

    installShellCompletion --cmd platformio \
      --bash <(_PLATFORMIO_COMPLETE=bash_source $out/bin/platformio) \
      --zsh <(_PLATFORMIO_COMPLETE=zsh_source $out/bin/platformio) \
      --fish <(_PLATFORMIO_COMPLETE=fish_source $out/bin/platformio)

    installShellCompletion --cmd pio \
      --bash <(_PIO_COMPLETE=bash_source $out/bin/pio) \
      --zsh <(_PIO_COMPLETE=zsh_source $out/bin/pio) \
      --fish <(_PIO_COMPLETE=fish_source $out/bin/pio)
  '';

  disabledTestPaths = [
    "tests/commands/pkg/test_install.py"
    "tests/commands/pkg/test_list.py"
    "tests/commands/pkg/test_outdated.py"
    "tests/commands/pkg/test_search.py"
    "tests/commands/pkg/test_show.py"
    "tests/commands/pkg/test_uninstall.py"
    "tests/commands/pkg/test_update.py"
    "tests/commands/test_boards.py"
    "tests/commands/test_check.py"
    "tests/commands/test_platform.py"
    "tests/commands/test_run.py"
    "tests/commands/test_test.py"
    "tests/misc/test_maintenance.py"
    # requires internet connection
    "tests/misc/ino2cpp/test_ino2cpp.py"
  ];

  disabledTests = [
    # requires internet connection
    "test_api_cache"
    "test_ping_internet_ips"
    "test_metadata_dump"
  ];

  pytestFlagsArray = [
    "tests"
  ] ++ (map (e: "--deselect tests/${e}") [
    "commands/pkg/test_exec.py::test_pkg_specified"
    "commands/pkg/test_exec.py::test_unrecognized_options"
    "commands/test_ci.py::test_ci_boards"
    "commands/test_ci.py::test_ci_build_dir"
    "commands/test_ci.py::test_ci_keep_build_dir"
    "commands/test_ci.py::test_ci_lib_and_board"
    "commands/test_ci.py::test_ci_project_conf"
    "commands/test_init.py::test_init_custom_framework"
    "commands/test_init.py::test_init_duplicated_boards"
    "commands/test_init.py::test_init_enable_auto_uploading"
    "commands/test_init.py::test_init_ide_atom"
    "commands/test_init.py::test_init_ide_clion"
    "commands/test_init.py::test_init_ide_eclipse"
    "commands/test_init.py::test_init_ide_vscode"
    "commands/test_init.py::test_init_incorrect_board"
    "commands/test_init.py::test_init_special_board"
    "commands/test_lib.py::test_global_install_archive"
    "commands/test_lib.py::test_global_install_registry"
    "commands/test_lib.py::test_global_install_repository"
    "commands/test_lib.py::test_global_lib_list"
    "commands/test_lib.py::test_global_lib_uninstall"
    "commands/test_lib.py::test_global_lib_update"
    "commands/test_lib.py::test_global_lib_update_check"
    "commands/test_lib.py::test_install_duplicates"
    "commands/test_lib.py::test_lib_show"
    "commands/test_lib.py::test_lib_stats"
    "commands/test_lib.py::test_saving_deps"
    "commands/test_lib.py::test_search"
    "commands/test_lib.py::test_update"
    "commands/test_lib_complex.py::test_global_install_archive"
    "commands/test_lib_complex.py::test_global_install_registry"
    "commands/test_lib_complex.py::test_global_install_repository"
    "commands/test_lib_complex.py::test_global_lib_list"
    "commands/test_lib_complex.py::test_global_lib_uninstall"
    "commands/test_lib_complex.py::test_global_lib_update"
    "commands/test_lib_complex.py::test_global_lib_update_check"
    "commands/test_lib_complex.py::test_install_duplicates"
    "commands/test_lib_complex.py::test_lib_show"
    "commands/test_lib_complex.py::test_lib_stats"
    "commands/test_lib_complex.py::test_search"
    "package/test_manager.py::test_download"
    "package/test_manager.py::test_install_force"
    "package/test_manager.py::test_install_from_registry"
    "package/test_manager.py::test_install_lib_depndencies"
    "package/test_manager.py::test_registry"
    "package/test_manager.py::test_uninstall"
    "package/test_manager.py::test_update_with_metadata"
    "package/test_manager.py::test_update_without_metadata"
    "test_builder.py::test_build_flags"
    "test_builder.py::test_build_unflags"
    "test_builder.py::test_debug_custom_build_flags"
    "test_builder.py::test_debug_default_build_flags"
    "test_misc.py::test_api_cache"
    "test_misc.py::test_ping_internet_ips"
    "test_misc.py::test_platformio_cli"
    "test_pkgmanifest.py::test_packages"
  ]);

  passthru = {
    python = python3Packages.python;
  };

  meta = with lib; {
    changelog = "https://github.com/platformio/platformio-core/releases/tag/v${version}";
    description = "Open source ecosystem for IoT development";
    downloadPage = "https://github.com/platformio/platformio-core";
    homepage = "https://platformio.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ mog makefu ];
    mainProgram = "platformio";
  };
}
