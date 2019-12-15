{ stdenv, lib, buildPythonApplication, fetchFromGitHub
, bottle, click, colorama
, lockfile, pyserial, requests
, pytest, semantic-version, tox, tabulate, pyelftools
, jsondiff, git
# Marshmallow deps
, buildPythonPackage, fetchPypi, dateutil, simplejson
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

  # Waiting for marshmallow 3.0 support - https://github.com/platformio/platformio-core/pull/3296
  marshmallow = buildPythonPackage rec {
    pname = "marshmallow";
    version = "2.20.5";

    meta = {
      homepage = "https://github.com/marshmallow-code/marshmallow";
      description = ''
        A lightweight library for converting complex objects to and from
        simple Python datatypes.
      '';
      license = lib.licenses.mit;
    };

    src = fetchPypi {
      inherit pname version;
      sha256 = "19yb2936ay2fc9aby4lyzscipf9gd9lk0zwjy7wm3b5j84pqj87f";
    };

    propagatedBuildInputs = [ dateutil simplejson ];

    doCheck = false;
  };

  spdx = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/spdx/license-list-data/v3.6/json/licenses.json";
    sha256 = "1knwbfhd1gxr0b9cbxizajvnhr67yfmaq6ds3ajvsjmyqp7bk0cl";
  };

in buildPythonApplication rec {
  pname = "platformio";
  version = "4.1.0";

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    rev = "v${version}";
    sha256 = "10v9jw1zjfqr3wl6kills3cfp0ky7xbm1gc3z0n57wrqbc6cmz95";
  };

  propagatedBuildInputs =  [
    bottle click colorama git jsondiff
    lockfile marshmallow pyelftools
    pyserial requests semantic-version
    tabulate
  ];

  HOME = "/tmp";

  checkInputs = [ pytest tox ];

  checkPhase = ''
    runHook preCheck

    export SPDX_LICENSE_FILE="${spdx}"
    py.test -v tests ${args}

    runHook postCheck
  '';

  patches = [
    ./fix-schema-tests.patch
    ./fix-searchpath.patch
  ];

  meta = with stdenv.lib; {
    broken = stdenv.isAarch64;
    description = "An open source ecosystem for IoT development";
    homepage = http://platformio.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ mog makefu ];
  };
}
