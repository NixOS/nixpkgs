{
  buildPecl,
  fetchFromGitHub,
  lib,
  php,
  pkg-config,
  dlib,
}:

buildPecl (finalAttrs: {
  pname = "pdlib";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "goodspb";
    repo = "pdlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AKZ3F2XzEQCeZkacSXBinxeGQrHBmqjP7mDGQ3RBAiE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ (dlib.override { guiSupport = true; }) ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    description = "PHP extension for Dlib";
    license = lib.licenses.mit;
    homepage = "https://github.com/goodspb/pdlib";
    teams = [ lib.teams.php ];
  };
})
