{ stdenv, lib, python3
, fetchFromGitHub
, fetchPypi
, git
, spdx-license-list-data
, version, src
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      starlette = super.starlette.overridePythonAttrs (oldAttrs: rec {
        version = "0.20.0";
        src = fetchFromGitHub {
          owner = "encode";
          repo = "starlette";
          rev = version;
          sha256 = "sha256-bSgPjKqM262PSufz1LHwrdM+uU8xO55Mifv66HRN02Y=";
        };
      });
    };
  };
in
with python.pkgs; buildPythonApplication rec {
  pname = "platformio";
  inherit version src;

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

  HOME = "/tmp";

  checkInputs = [
    jsondiff
    pytestCheckHook
    tox
  ];

  pytestFlagsArray = (map (e: "--deselect tests/${e}") [
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
  ]) ++ (map (e: "--ignore=tests/${e}") [
    "commands/pkg/test_install.py"
    "commands/pkg/test_list.py"
    "commands/pkg/test_outdated.py"
    "commands/pkg/test_search.py"
    "commands/pkg/test_show.py"
    "commands/pkg/test_uninstall.py"
    "commands/pkg/test_update.py"
    "commands/test_boards.py"
    "commands/test_check.py"
    "commands/test_platform.py"
    "commands/test_run.py"
    "commands/test_test.py"
    "commands/test_update.py"
    "test_ino2cpp.py"
    "test_maintenance.py"
  ]) ++ [
    "tests"
  ];

  patches = [
    ./fix-searchpath.patch
    ./use-local-spdx-license-list.patch
    ./missing-udev-rules-nixos.patch
  ];

  postPatch = ''
    substitute platformio/package/manifest/schema.py platformio/package/manifest/schema.py \
      --subst-var-by SPDX_LICENSE_LIST_DATA '${spdx-license-list-data.json}'

    substituteInPlace setup.py \
      --replace 'uvicorn==%s" % ("0.17.*"' 'uvicorn==%s" % ("0.18.*"'
  '';

  meta = with lib; {
    broken = stdenv.isAarch64;
    description = "An open source ecosystem for IoT development";
    homepage = "https://platformio.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ mog makefu ];
  };
}
