{ stdenv, fetchFromGitHub, glib, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-switcher";
  version = "master";

  src = fetchFromGitHub {
    owner = "daniellandau";
    repo = "switcher";
    rev = "${version}";
    sha256 = "0avzr1vza4fi29yy9dvs41vw98b39xzi1cp4yfrbl4g4gflkp2y4";
  };

  uuid = "switcher@landau.fi";

  nativeBuildInputs = [
    glib 
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ./ $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description =
      "GNOME Shell extension to switch windows or launch applications quickly by typing";
    license = licenses.gpl3Plus;
    #maintainers = with maintainers; [ chickensoupwithrice ];
    homepage = "https://github.com/daniellandau/switcher";
  };
}
