{ lib
, stdenv
, fetchFromGitHub
, glib
, substituteAll
, hddtemp
, liquidctl
, lm_sensors
, netcat-gnu
, nvme-cli
, procps
, smartmontools
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-freon";
  version = "45";

  passthru = {
    extensionUuid = "freon@UshakovVasilii_Github.yahoo.com";
    extensionPortalSlug = "freon";
  };

  src = fetchFromGitHub {
    owner = "UshakovVasilii";
    repo = "gnome-shell-extension-freon";
    rev = "EGO-${version}";
    sha256 = "sha256-tPb7SzHSwvz7VV+kZTmcw1eAdtL1J7FJ3BOtg4Us8jc=";
  };

  nativeBuildInputs = [ glib ];

  patches = [
    (substituteAll {
      src = ./fix_paths.patch;
      inherit hddtemp liquidctl lm_sensors procps smartmontools;
      netcat = netcat-gnu;
      nvmecli = nvme-cli;
    })
  ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict --targetdir="freon@UshakovVasilii_Github.yahoo.com/schemas" "freon@UshakovVasilii_Github.yahoo.com/schemas"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r "freon@UshakovVasilii_Github.yahoo.com" $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "GNOME Shell extension for displaying CPU, GPU, disk temperatures, voltage and fan RPM in the top panel";
    license = licenses.gpl2;
    maintainers = with maintainers; [ justinas ];
    homepage = "https://github.com/UshakovVasilii/gnome-shell-extension-freon";
  };
}
