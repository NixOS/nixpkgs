{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "trzsz-go";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-go";
    rev = "v${version}";
    hash = "sha256-E9mp41bhBoRZCXFkLNn/ZV1XZeDf0KzbXOhVxt0bFF4=";
  };

  vendorHash = "sha256-XSVN2Qv3DXiAVZGxyCJoQoFKAPQMHp6j8f+MYfbOw/w=";

  meta = with lib; {
    description = "Makes all terminals that support local shell to support trzsz";
    homepage = "https://github.com/trzsz/trzsz-go";
    license = licenses.mit;
    maintainers = [maintainers.ztmzzz];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
  };
}
