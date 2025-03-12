{
  stdenv,
  lib,
  buildPythonPackage,
  click,
  colorama,
  fetchPypi,
  gitMinimal,
  gnugrep,
  gnupg,
  pbr,
  pexpect,
  pythonAtLeast,
  pytestCheckHook,
  setuptools,
  replaceVars,
  tree,
  xclip,
}:

# Use the `pypass` top-level attribute, if you're interested in the
# application
buildPythonPackage rec {
  pname = "pypass";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+dAQiufpULdU26or4EKDqazQbOZjGRbhI/+ddo+spNo=";
  };

  # Set absolute nix store paths to the executables that pypass uses
  patches = [
    (replaceVars ./mark-executables.patch {
      git_exec = "${gitMinimal}/bin/git";
      grep_exec = "${gnugrep}/bin/grep";
      gpg_exec = "${gnupg}/bin/gpg2";
      tree_exec = "${tree}/bin/tree";
      xclip_exec = "${xclip}/bin/xclip";
    })
  ];

  # Remove enum34 requirement if Python >= 3.4
  pythonRemoveDeps = lib.optionals (pythonAtLeast "3.4") [
    "enum34"
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [ pbr ];

  dependencies = [
    click
    colorama
    pexpect
  ];

  nativeCheckInputs = [
    gitMinimal
    pytestCheckHook
  ];

  # Configuration so that the tests work
  preCheck = ''
    export HOME=$(mktemp -d)
    export GNUPGHOME=pypass/tests/gnupg
    git config --global user.email "nix-builder@nixos.org"
    git config --global user.name "Nix Builder"
    git config --global pull.ff only
    make setup_gpg
  '';

  # Presumably this test needs the X clipboard, which we don't have
  # as the test environment is non-graphical.
  disabledTests = [ "test_show_clip" ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Password manager pass in Python";
    mainProgram = "pypass";
    homepage = "https://github.com/aviau/python-pass";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
