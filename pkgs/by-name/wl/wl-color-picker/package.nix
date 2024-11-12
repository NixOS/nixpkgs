{ lib
, stdenv
, fetchFromGitHub
, slurp
, grim
, zenity
, wl-clipboard
, imagemagick
, makeWrapper
, bash
}:

stdenv.mkDerivation rec {
  pname = "wl-color-picker";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "jgmdev";
    repo = "wl-color-picker";
    rev = "v${version}";
    sha256 = "sha256-lvhpXy4Sd1boYNGhbPoZTJlBhlW5obltDOrEzB1Gq0A=";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace 'which' 'ls' \
      --replace 'grim' "${grim}/bin/grim" \
      --replace 'slurp' "${slurp}/bin/slurp" \
      --replace 'convert' "${imagemagick}/bin/convert" \
      --replace 'zenity' "${zenity}/bin/zenity" \
      --replace 'wl-copy' "${wl-clipboard}/bin/wl-copy"
  '';

  installFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  postInstall = ''
    wrapProgram $out/usr/bin/wl-color-picker \
      --prefix PATH : ${lib.makeBinPath [
         grim
         slurp
         imagemagick
         zenity
         wl-clipboard
       ]}
    mkdir -p $out/bin
    ln -s $out/usr/bin/wl-color-picker $out/bin/wl-color-picker
  '';

  meta = with lib; {
    description = "Wayland color picker that also works on wlroots";
    homepage = "https://github.com/jgmdev/wl-color-picker";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
    mainProgram = "wl-color-picker";
  };
}
