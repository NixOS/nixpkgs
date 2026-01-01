{
  buildPecl,
  fetchFromGitHub,
  lib,
  pkg-config,
  dlib,
}:
let
  pname = "pdlib";
  version = "1.1.0";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "goodspb";
    repo = "pdlib";
    rev = "v${version}";
    sha256 = "sha256-AKZ3F2XzEQCeZkacSXBinxeGQrHBmqjP7mDGQ3RBAiE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ (dlib.override { guiSupport = true; }) ];

<<<<<<< HEAD
  meta = {
    description = "PHP extension for Dlib";
    license = with lib.licenses; [ mit ];
=======
  meta = with lib; {
    description = "PHP extension for Dlib";
    license = with licenses; [ mit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/goodspb/pdlib";
    teams = [ lib.teams.php ];
  };
}
