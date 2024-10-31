{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "qmk_dotty_dict";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pawelzny";
    repo = "dotty_dict";
    rev = "refs/tags/v${version}";
    hash = "sha256-kY7o9wgfsV7oc5twOeuhG47C0Js6JzCt02S9Sd8dSGc=";
  };

  nativeBuildInputs = [ poetry-core ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pawelzny/dotty_dict";
    description = "Dictionary wrapper for quick access to deeply nested keys";
    longDescription = ''
      This is a version of dotty-dict by QMK (https://qmk.fm) since the original
      dotty-dict published to pypi has non-ASCII characters that breaks with
      some non-UTF8 locale settings.
    '';
    license = licenses.mit;
    maintainers = [ ];
  };
}
