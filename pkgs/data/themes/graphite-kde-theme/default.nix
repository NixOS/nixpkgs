{
  stdenv,
  lib,
  fetchFromGitHub,
  kdeclarative,
  plasma-framework,
  plasma-workspace,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "graphite-kde-theme";
  version = "unstable-2023-10-25";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "33cc85c49c424dfcba73e6ee84b0dc7fb9e52566";
    hash = "sha256-iQGT2x0wY2EIuYw/a1MB8rT9BxiqWrOyBo6EGIJwsFw=";
  };

  # Propagate sddm theme dependencies to user env otherwise sddm does
  # not find them. Putting them in buildInputs is not enough.
  propagatedUserEnvPkgs = [
    kdeclarative.bin
    plasma-framework
    plasma-workspace
  ];

  postPatch = ''
    patchShebangs install.sh

    substituteInPlace install.sh \
      --replace '$HOME/.local' $out \
      --replace '$HOME/.config' $out/share

    substituteInPlace sddm/*/Main.qml \
      --replace /usr $out
  '';

  installPhase = ''
    runHook preInstall

    name= ./install.sh

    mkdir -p $out/share/sddm/themes
    cp -a sddm/Graphite* $out/share/sddm/themes/

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A flat Design theme for KDE Plasma desktop";
    homepage = "https://github.com/vinceliuice/Graphite-kde-theme";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
