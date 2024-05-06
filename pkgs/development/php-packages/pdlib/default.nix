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

  meta = with lib; {
    description = "A PHP extension for Dlib";
    license = with licenses; [ mit ];
    homepage = "https://github.com/goodspb/pdlib";
    maintainers = lib.teams.php.members;
  };
}
