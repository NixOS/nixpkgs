{ stdenv, lib, python3
, fetchFromGitHub
, fetchPypi
, git
, spdx-license-list-data
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "platformio";

  version = "6.1.6";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "sha256-BEeMfdmAWqFbQUu8YKKrookQVgmhfZBqXnzeb2gfhms=";
  };

  outputs = [ "out" "udev" ];

  patches = [
    ./fix-searchpath.patch
    ./use-local-spdx-license-list.patch
    ./missing-udev-rules-nixos.patch
  ];

  postPatch = ''
    substitute platformio/package/manifest/schema.py platformio/package/manifest/schema.py \
      --subst-var-by SPDX_LICENSE_LIST_DATA '${spdx-license-list-data.json}'

    substituteInPlace setup.py \
      --replace 'aiofiles==%s" % ("0.8.0" if PY36 else "22.1.*")' 'aiofiles"' \
      --replace 'starlette==%s" % ("0.19.1" if PY36 else "0.23.*")' 'starlette"' \
      --replace 'uvicorn==%s" % ("0.16.0" if PY36 else "0.20.*")' 'uvicorn"' \
      --replace 'tabulate==%s" % ("0.8.10" if PY36 else "0.9.*")' 'tabulate>=0.8.10,<=0.9"' \
      --replace 'wsproto==%s" % ("1.0.0" if PY36 else "1.2.*")' 'wsproto"'
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

  nativeCheckInputs = [
    jsondiff
    pytestCheckHook
  ];

  # Install udev rules into a separate output so all of platformio-core is not a dependency if
  # you want to use the udev rules on NixOS but not install platformio in your system packages.
  postInstall = ''
    mkdir -p $udev/lib/udev/rules.d
    cp platformio/assets/system/99-platformio-udev.rules $udev/lib/udev/rules.d/99-platformio-udev.rules
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
    python = python3;
  };

  meta = with lib; {
    description = "An open source ecosystem for IoT development";
    homepage = "https://platformio.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ mog makefu ];
  };
}
