{ stdenv, lib, buildPythonApplication, fetchFromGitHub, fetchpatch
, bottle, click, colorama, semantic-version
, lockfile, pyserial, requests
, tabulate, pyelftools, marshmallow
, pytest, tox, jsondiff
, git, spdx-license-list-data
}:

let
  args = lib.concatStringsSep " " ((map (e: "--deselect tests/${e}") [
    "commands/test_ci.py::test_ci_boards"
    "commands/test_ci.py::test_ci_project_conf"
    "commands/test_ci.py::test_ci_lib_and_board"
    "commands/test_ci.py::test_ci_build_dir"
    "commands/test_ci.py::test_ci_keep_build_dir"
    "commands/test_init.py::test_init_enable_auto_uploading"
    "commands/test_init.py::test_init_custom_framework"
    "commands/test_init.py::test_init_incorrect_board"
    "commands/test_init.py::test_init_ide_atom"
    "commands/test_init.py::test_init_ide_eclipse"
    "commands/test_init.py::test_init_duplicated_boards"
    "commands/test_init.py::test_init_special_board"
    "commands/test_lib.py::test_search"
    "commands/test_lib.py::test_install_duplicates"
    "commands/test_lib.py::test_global_lib_update_check"
    "commands/test_lib.py::test_global_lib_update"
    "commands/test_lib.py::test_global_lib_uninstall"
    "commands/test_lib.py::test_lib_show"
    "commands/test_lib.py::test_lib_stats"
    "commands/test_lib.py::test_global_install_registry"
    "commands/test_lib.py::test_global_install_archive"
    "commands/test_lib.py::test_global_install_repository"
    "commands/test_lib.py::test_global_lib_list"
    "commands/test_test.py::test_local_env"
    "test_builder.py::test_build_flags"
    "test_builder.py::test_build_unflags"
    "test_builder.py::test_debug_default_build_flags"
    "test_builder.py::test_debug_custom_build_flags"
    "test_misc.py::test_api_cache"
    "test_misc.py::test_ping_internet_ips"
    "test_misc.py::test_platformio_cli"
    "test_pkgmanifest.py::test_packages"
  ]) ++ (map (e: "--ignore=tests/${e}") [
    "commands/test_boards.py"
    "commands/test_check.py"
    "commands/test_platform.py"
    "commands/test_update.py"
    "test_maintenance.py"
    "test_ino2cpp.py"
  ]));

in buildPythonApplication rec {
  pname = "platformio";
  version = "4.3.1";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "1dxnjy60zpkgyrbvbf6b9qi6m37gm8gwjmxwfj30npr1y7rvxwrw";
  };

  propagatedBuildInputs =  [
    bottle click colorama git lockfile
    pyserial requests semantic-version
    tabulate pyelftools marshmallow
  ];

  HOME = "/tmp";

  checkInputs = [ pytest tox jsondiff ];

  checkPhase = ''
    runHook preCheck

    py.test -v tests ${args}

    runHook postCheck
  '';

  patches = [
    ./fix-searchpath.patch
    ./use-local-spdx-license-list.patch
  ];

  postPatch = ''
    substitute platformio/package/manifest/schema.py platformio/package/manifest/schema.py \
      --subst-var-by SPDX_LICENSE_LIST_DATA '${spdx-license-list-data}'
  '';

  meta = with stdenv.lib; {
    broken = stdenv.isAarch64;
    description = "An open source ecosystem for IoT development";
    homepage = "http://platformio.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ mog makefu ];
  };
}
