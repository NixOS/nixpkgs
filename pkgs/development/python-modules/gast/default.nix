{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, astunparse
}:

buildPythonPackage rec {
  pname = "gast";
  version = "0.5.0";

  # TODO: remove this patch on the next release, this fixes a bug with parsing
  # assignment expressions e.g., `x := 1`.
  patches = [
    (fetchpatch {
      url = "https://github.com/serge-sans-paille/gast/commit/3cc9b4d05a80e4bb42882de00df314aaa1e6e591.patch";
      sha256 = "0ylpn0x0a4y6139vd048blsh77yd08npjcn4b5ydf89xnji5mlm1";
    })
  ];
  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "gast";
    rev = version;
    sha256 = "0qsg36knv0k2ppzbr5m4w6spxxw7a77lw88y8vjx7m176bajnsbw";
  };
  checkInputs = [ astunparse ];
  meta = with lib; {
    description = "GAST provides a compatibility layer between the AST of various Python versions, as produced by ast.parse from the standard ast module.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp cpcloud ];
  };
}
