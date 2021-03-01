{ buildPecl, lib, pkgs }:
let
  pname = "pdlib";
  version = "1.0.2";
in
buildPecl {
  inherit pname version;

  src = pkgs.fetchFromGitHub {
    owner = "goodspb";
    repo = "pdlib";
    rev = "v${version}";
    sha256 = "0qnmqwlw5vb2rvliap4iz9val6mal4qqixcw69pwskdw5jka6v5i";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ (pkgs.dlib.override { guiSupport = true; }) ];

  meta = with lib; {
    description = "A PHP extension for Dlib";
    license = with licenses; [ mit ];
    maintainers = lib.teams.php.members;
  };
}
