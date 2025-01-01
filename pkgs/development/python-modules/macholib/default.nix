{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  unittestCheckHook,
  altgraph,
  setuptools,
  typing-extensions,
  pyinstaller,
}:

buildPythonPackage rec {
  pname = "macholib";
  version = "1.16.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bTql10Ceny4fBCxnEWz1m1wi03EWMDW9u99IQiWYbnY=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
      altgraph
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      typing-extensions
    ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  passthru.tests = {
    inherit pyinstaller; # Requires macholib for darwin
  };

  preCheck = ''
    export PATH="$PATH:$out/bin"
  '';

  meta = with lib; {
    description = "Analyze and edit Mach-O headers, the executable format used by Mac OS X.";
    homepage = "https://github.com/ronaldoussoren/macholib";
    changelog = "https://github.com/ronaldoussoren/macholib/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ eveeifyeve ];
  };
}
