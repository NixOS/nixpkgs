{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  altgraph,
  setuptools,
  pyinstaller,
  bashNonInteractive,
  coreutils,
}:

let
  coreutils' = coreutils.override { singleBinary = false; };
in
buildPythonPackage rec {
  pname = "macholib";
  version = "1.16.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "macholib";
    rev = "v${version}";
    hash = "sha256-+7dFPwzwKmvtDY/blLNyrNDEATcgo+BUceoSGg55gbo=";
  };

  # test_command_line.py::test_shared_main requires that /bin/sh and
  # /bin/ls exist and are regular executables (not symlinks).
  # It also dislikes something about the real /bin.
  postPatch = lib.optionalString doCheck ''
    substituteInPlace macholib_tests/test_command_line.py \
      --replace-fail '"/bin/sh"' '"${lib.getExe' bashNonInteractive "bash"}"' \
      --replace-fail '"/bin/ls"' '"${lib.getExe' coreutils' "ls"}"' \
      --replace-fail '"/bin"' '"${lib.getBin coreutils'}/bin"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    altgraph
  ];

  # Checks assume to find darwin specific libraries
  doCheck = stdenv.buildPlatform.isDarwin;
  nativeCheckInputs = [
    bashNonInteractive
    coreutils'
    unittestCheckHook
  ];

  passthru.tests = {
    inherit pyinstaller; # Requires macholib for darwin
  };

  preCheck = ''
    export PATH="$PATH:$out/bin"
  '';

  meta = {
    description = "Analyze and edit Mach-O headers, the executable format used by Mac OS X";
    homepage = "https://github.com/ronaldoussoren/macholib";
    changelog = "https://github.com/ronaldoussoren/macholib/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eveeifyeve ];
  };
}
