{
  stdenv,
  lib,
  buildPythonPackage,
  click,
  colorama,
  fetchPypi,
  git,
  gnugrep,
  gnupg,
  pbr,
  pexpect,
  pythonAtLeast,
  pytestCheckHook,
  substituteAll,
  tree,
  xclip,
}:

# Use the `pypass` top-level attribute, if you're interested in the
# application
buildPythonPackage rec {
  pname = "pypass";
  version = "0.2.1";
  format = "setuptools";

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
  postPatch = lib.optionalString (pythonAtLeast "3.4") ''
    substituteInPlace requirements.txt --replace "enum34" ""
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    click
    colorama
    pexpect
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Configuration so that the tests work
  preCheck = ''
    export HOME=$(mktemp -d)
    export GNUPGHOME=pypass/tests/gnupg
    ${git}/bin/git config --global user.email "nix-builder@nixos.org"
    ${git}/bin/git config --global user.name "Nix Builder"
    ${git}/bin/git config --global pull.ff only
    make setup_gpg
  '';

  # Presumably this test needs the X clipboard, which we don't have
  # as the test environment is non-graphical.
  disabledTests = [ "test_show_clip" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Password manager pass in Python";
    mainProgram = "pypass";
    homepage = "https://github.com/aviau/python-pass";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
}
