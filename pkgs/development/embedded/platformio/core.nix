{ stdenv, lib, python3
, fetchFromGitHub
, fetchPypi
, git
, spdx-license-list-data
, version, src
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "platformio";
  inherit version src;

  patches = [
    ./fix-searchpath.patch
    ./use-local-spdx-license-list.patch
    ./missing-udev-rules-nixos.patch
  ];

  postPatch = ''
    substitute platformio/package/manifest/schema.py platformio/package/manifest/schema.py \
      --subst-var-by SPDX_LICENSE_LIST_DATA '${spdx-license-list-data.json}'

    substituteInPlace setup.py \
      --replace 'uvicorn==%s" % ("0.16.0" if PY36 else "0.19.*")' 'uvicorn>=0.16"' \
      --replace 'starlette==%s" % ("0.19.1" if PY36 else "0.21.*")' 'starlette>=0.19.1,<=0.21"' \
      --replace 'tabulate==%s" % ("0.8.10" if PY36 else "0.9.*")' 'tabulate>=0.8.10,<=0.9"' \
      --replace 'wsproto==' 'wsproto>='
  '';

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
    spdx-license-list-data.json
    starlette
    tabulate
    uvicorn
    wsproto
    zeroconf
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$PATH:$out/bin
  '';

  checkInputs = [
    jsondiff
    pytestCheckHook
  ];

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

  meta = with lib; {
    description = "An open source ecosystem for IoT development";
    homepage = "https://platformio.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ mog makefu ];
  };
}
