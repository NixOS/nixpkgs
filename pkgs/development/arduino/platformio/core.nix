{ stdenv, lib, buildPythonApplication, fetchFromGitHub
, bottle, click, colorama
, lockfile, pyserial, requests
, pytest, semantic-version, tox
, git
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
    "test_misc.py::test_api_cache"
    "test_misc.py::test_ping_internet_ips"
    "test_pkgmanifest.py::test_packages"
  ]) ++ (map (e: "--ignore=tests/${e}") [
    "commands/test_boards.py"
    "commands/test_platform.py"
    "commands/test_update.py"
    "test_maintenance.py"
    "test_ino2cpp.py"
  ]));

in buildPythonApplication rec {
  pname = "platformio";
  version = "3.6.6";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "1qwd6684y2xagl375sv8fm6a535hcdqx296hknjlbvsgc1jc514a";
  };

  propagatedBuildInputs =  [
    bottle click colorama git lockfile
    pyserial requests semantic-version
  ];

  HOME = "/tmp";

  checkInputs = [ pytest tox ];

  checkPhase = ''
    runHook preCheck

    py.test -v tests ${args}

    runHook postCheck
  '';

  patches = [ ./fix-searchpath.patch ];

  meta = with stdenv.lib; {
    broken = stdenv.isAarch64;
    description = "An open source ecosystem for IoT development";
    homepage = http://platformio.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ mog makefu ];
  };
}
