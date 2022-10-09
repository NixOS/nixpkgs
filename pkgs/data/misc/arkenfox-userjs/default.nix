{ lib, fetchurl, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "arkenfox-userjs";
  version = "105.0";

  src = fetchurl {
    url = "https://github.com/arkenfox/user.js/raw/${version}/user.js";
    hash = "sha256-4v5VcCj5h+pLZ7wt38AoWUQgg62qPGohWwmY6yNZZ/0=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    ln -s ${src} $out/user.js
    cp ${src} $out/user.cfg
    substituteInPlace $out/user.cfg \
      --replace "user_pref" "defaultPref"
  '';

  meta = with lib; {
    description = "A comprehensive user.js template for configuration and hardening";
    homepage = "https://github.com/arkenfox/user.js";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ linsui ];
  };
}
