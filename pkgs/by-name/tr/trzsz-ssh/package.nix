{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "trzsz-ssh";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-ssh";
    rev = "v${version}";
    hash = "sha256-xgcAzW+toUGccLTsoKMeyzbB//nTYj5nn3wEbptRX0U=";
  };

  vendorHash = "sha256-WYc7Ls3NMsKi/eDr2CX1ATKCIHoiWecZ8WvqscWxS1U=";

  meta = with lib; {
    description = "An alternative to ssh client, offers additional useful features";
    homepage = "https://github.com/trzsz/trzsz-ssh";
    license = licenses.mit;
    maintainers = [maintainers.ztmzzz];
    mainProgram = "tssh";
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
  };
}
