{ buildPythonPackage
, click
, colorama
, enum34
, fetchPypi
, git
, gnugrep
, gnupg
, nose
, pbr
, pexpect
, pythonAtLeast
, pythonOlder
, stdenv
, substituteAll
, tree
, xclip
}:

# NOTE: pypass can also be used as an application, but probably the most
# important usecase is as a library. So, let's use buildPythonPackage and
# support any Python version instead of defining it as an application with
# buildPythonApplication.
buildPythonPackage rec {
  pname = "pypass";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nm4mj7pd7gz4ghic6b3wrnd1b59hd1f0axavdabfl79wy511l7r";
  };

  # Set absolute nix store paths to the executables that pypass uses
  patches = [
    (substituteAll {
      src = ./mark-executables.patch;
      git_exec = "${git}/bin/git";
      grep_exec = "${gnugrep}/bin/grep";
      gpg_exec = "${gnupg}/bin/gpg2";
      tree_exec = "${tree}/bin/tree";
      xclip_exec = "${xclip}/bin/xclip";
    })
  ];

  # Remove enum34 requirement if Python >= 3.4
  postPatch = stdenv.lib.optionalString (pythonAtLeast "3.4") ''
    substituteInPlace requirements.txt --replace "enum34" ""
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    click
    colorama
    pexpect
  ] ++ stdenv.lib.optional (pythonOlder "3.4") enum34;

  checkInputs = [ nose ];

  # Configuration so that the tests work
  preCheck = ''
    HOME=$TEMP ${git}/bin/git config --global user.email "nix-builder@nixos.org"
    HOME=$TEMP ${git}/bin/git config --global user.name "Nix Builder"
    HOME=$TEMP ${git}/bin/git config --global pull.ff only
    HOME=$TEMP make setup_gpg
  '';

  # Run tests but exclude the test that uses clipboard as I wasn't able to make
  # it work - probably the X clipboard just doesn't work in the build
  # environment..
  checkPhase = ''
    runHook preCheck
    HOME=$TEMP GNUPGHOME=pypass/tests/gnupg nosetests -v --exclude=test_show_clip .
    runHook postCheck
  '';

  meta = {
    description = "Password manager pass in Python";
    homepage = "https://github.com/aviau/python-pass";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ jluttine ];
  };
}
