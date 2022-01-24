{ buildPecl, fetchFromGitHub, lib, pkg-config, dlib }:
let
  pname = "pdlib";
  version = "1.0.2";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "goodspb";
    repo = "pdlib";
    rev = "v${version}";
    sha256 = "0qnmqwlw5vb2rvliap4iz9val6mal4qqixcw69pwskdw5jka6v5i";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ (dlib.override { guiSupport = true; }) ];

  meta = with lib; {
    description = "A PHP extension for Dlib";
    license = with licenses; [ mit ];
    homepage = "https://github.com/goodspb/pdlib";
    maintainers = lib.teams.php.members;
  };
}
