{
  stdenv,
  fetchFromGitHub,
  theme,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "gtk-theme-framework";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "jaxwilko";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z5s5rsgiypanf2z0avaisbflnvwrc8aiy5qskrsvbbaja63jy3s";
  };

  postPatch = ''
    substituteInPlace main.sh \
      --replace "#!/usr/bin/env bash" "#!/bin/sh"

    substituteInPlace scripts/install.sh \
      --replace "#!/usr/bin/env bash" "#!/bin/sh"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    ./main.sh -i -t ${theme} -d $out/share/themes

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/jaxwilko/gtk-theme-framework";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
