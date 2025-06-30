{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "xmonad-log";
  version = "0.1.0-unstable-2024-06-14";

  src = fetchFromGitHub {
    owner = "xintron";
    repo = "xmonad-log";
    rev = "70c76d59c22cf5f412467cd42fa9ff34eeb2bd1b";
    hash = "sha256-hDYb3mSX2+FX/2uazCKPXmNj0avDlutwSMjST7wLBVY=";
  };

  vendorHash = "sha256-58zK6t3rb+19ilaQaNgsMVFQBYKPIV40ww8klrGbpnw=";
  proxyVendor = true;

  meta = with lib; {
    description = "xmonad DBus monitoring solution";
    homepage = "https://github.com/xintron/xmonad-log";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ joko ];
    mainProgram = "xmonad-log";
  };
}
