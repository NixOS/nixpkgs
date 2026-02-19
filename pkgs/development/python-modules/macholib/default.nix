{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  altgraph,
  setuptools,
  pyinstaller,
}:

buildPythonPackage rec {
  pname = "macholib";
  version = "1.16.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "macholib";
    rev = "v${version}";
    hash = "sha256-bTql10Ceny4fBCxnEWz1m1wi03EWMDW9u99IQiWYbnY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    altgraph
  ];

  # Checks assume to find darwin specific libraries
  doCheck = stdenv.buildPlatform.isDarwin;
  nativeCheckInputs = [
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
