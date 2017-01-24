{ stdenv, fetchFromGitHub, buildPythonPackage, python, isPy3k
, libselinux, libblockdev, libbytesize, pyparted, pyudev
, coreutils, utillinux, multipath-tools, lsof
# Test dependencies
, pocketlint, pep8, mock, writeScript
}:

buildPythonPackage rec {
  name = "blivet-${version}";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "blivet";
    rev = name;
    sha256 = "1z2s8dxwk5qpra7a27sqxzfahk89x8hgq2ff5qk6ymb7qzdkc1yj";
  };

  outputs = [ "out" "tests" ];

  # Only works with Python 3!
  disabled = !isPy3k;

  patches = [
    ./no-hawkey.patch ./test-fixes.patch ./uuids.patch ./ntfs-formattable.patch
  ];

  postPatch = ''
    cat > blivet/kickstart_stubs.py <<EOF
    AUTOPART_TYPE_PLAIN = 0
    AUTOPART_TYPE_BTRFS = 1
    AUTOPART_TYPE_LVM = 2
    AUTOPART_TYPE_LVM_THINP = 3

    CLEARPART_TYPE_LINUX = 0
    CLEARPART_TYPE_ALL = 1
    CLEARPART_TYPE_NONE = 2
    CLEARPART_TYPE_LIST = 3
    EOF

    # enable_installer_mode() imports lots of pyanaconda modules
    sed -i -e '/^def enable_installer_mode(/,/^[^ ]/ {
      /^\( \|$\|def enable_installer_mode(\)/d
    }' blivet/__init__.py

    # Remove another import of pyanaconda
    sed -i -e '/anaconda_flags/d' blivet/osinstall.py

    # Remove test involving pykickstart
    rm tests/blivet_test.py
    # Remove EDD tests, because they don't work within VM tests
    rm tests/devicelibs_test/edd_test.py

    # Replace imports of pykickstart with the stubs
    sed -i -e '
      s/^from pykickstart\.constants import/from blivet.kickstart_stubs import/
    ' blivet/autopart.py blivet/blivet.py tests/clearpart_test.py

    # patch in paths for multipath-tools
    sed -i -re '
      s!(run_program[^"]*")(multipath|kpartx)"!\1${multipath-tools}/bin/\2"!
    ' blivet/devices/disk.py blivet/devices/dm.py

    # make "kpartx" and "multipath" always available
    sed -i -re '
      s/^(KPARTX|MULTIPATH)_APP *=.*/\1_APP = available_resource("\L\1\E")/
    ' blivet/tasks/availability.py

    sed -i -e 's|"lsof"|"${lsof}/bin/lsof"|' blivet/formats/fs.py

    sed -i -e 's|"wipefs"|"${utillinux}/bin/wipefs"|' \
      blivet/formats/__init__.py tests/formats_test/methods_test.py
  '';

  checkInputs = [ pocketlint pep8 mock ];

  propagatedBuildInputs = [
    (libselinux.override { enablePython = true; inherit python; })
    libblockdev libbytesize pyparted pyudev
  ];

  postInstall = ''
    mkdir "$tests"
    cp -Rd tests "$tests/"
  '';

  # Real tests are in nixos/tests/blivet.nix, just run pylint and pep8 here.
  checkPhase = let
    inherit (stdenv.lib)
      intersperse concatLists concatMapStringsSep escapeShellArg;

    # Create find arguments that ignore a certain path.
    mkIgnorePath = path: [ "-path" "./${path}" "-prune" ];

    # Match files that have "python" in their shebangs
    matchPythonScripts = writeScript "match-python-scripts.sh" ''
      #!${stdenv.shell}
      head -n1 "$1" | grep -q '^#!.*python'
    '';

    # A list of arguments we're going to find in order to accumulate all the
    # files we want to test. This replicates the default behaviour of
    # pocketlint but with a few additional paths we want to have ignored.
    findArgs = concatLists (intersperse ["-o"] (map mkIgnorePath [
      # A set of paths we don't want to be tested.
      "translation-canary" "build" "dist" "scripts" "nix_run_setup.py"
    ])) ++ [
      "-o" "-name" "*.py" "-exec" "grep" "-qFx" "# pylint: skip-file" "{}" ";"
      "-o" "-type" "f" "("
        # These searches for files we actually *want* to match:
        "-name" "*.py" "-o" "-exec" matchPythonScripts "{}" ";"
      ")"
      # The actual test runner:
      "-exec" python.interpreter "tests/pylint/runpylint.py"
                                 # Pylint doesn't seem to pick up C modules:
                                 "--extension-pkg-whitelist=_ped" "{}" "+"
    ];
  in ''
    find ${concatMapStringsSep " " escapeShellArg findArgs}
    pep8 --ignore=E501,E402,E731 blivet/ tests/ examples/
  '';

  meta = with stdenv.lib; {
    homepage = "https://fedoraproject.org/wiki/Blivet";
    description = "Module for management of a system's storage configuration";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    platforms = platforms.linux;
  };
}
