{ lib, rustPlatform, fetchFromGitHub, pkg-config, libX11, libXcursor
, libxcb, python3, installShellFiles, makeDesktopItem, copyDesktopItems }:

rustPlatform.buildRustPackage rec {
  pname = "xcolor";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Soft";
    repo = pname;
    rev = version;
    sha256 = "sha256-NfmoBZek4hsga6RflE5EKkWarhCFIcTwEXhg2fpkxNE=";
  };

  cargoHash = "sha256-Zh73+FJ63SkusSavCqSCLbHVnU++4ZFSMFUIM7TnOj0=";

  nativeBuildInputs = [ pkg-config python3 installShellFiles copyDesktopItems ];

  buildInputs = [ libX11 libXcursor libxcb ];

  desktopItems = [
    (makeDesktopItem {
      name = "XColor";
      exec = "xcolor -s";
      desktopName = "XColor";
      comment = "Select colors visible anywhere on the screen to get their RGB representation";
      icon = "xcolor";
      categories = [ "Graphics" ];
    })
  ];

  postInstall = ''
    mkdir -p $out/share/applications

    installManPage man/xcolor.1
    for x in 16 24 32 48 256 512; do
        install -D -m644 extra/icons/xcolor-''${x}.png $out/share/icons/hicolor/''${x}x''${x}/apps/xcolor.png
    done
  '';

  meta = with lib; {
    description = "Lightweight color picker for X11";
    homepage = "https://github.com/Soft/xcolor";
    maintainers = with lib.maintainers; [ moni ];
    license = licenses.mit;
    mainProgram = "xcolor";
  };
}
