{ stdenv, lib, lndir }:

drv: pkgs:

stdenv.mkDerivation {
  name = "kde-env-${drv.name}";
  nativeBuildInputs = [ lndir ];
  envPkgs = builtins.map lib.getBin ([drv] ++ pkgs);
  unpackPhase = "true";
  configurePhase = "runHook preConfigure; runHook postConfigure";
  buildPhase = "true";
  installPhase = ''
    runHook preInstall

    propagated=""
    for i in $envPkgs; do
        findInputs $i propagated propagated-user-env-packages
    done

    for tgt in bin etc/xdg lib/libexec lib/qt5 share; do
        mkdir -p "$out/$tgt"
        for p in $propagated; do
            if [ -d "$p/$tgt" ]; then
                lndir -silent "$p/$tgt" "$out/$tgt" >/dev/null 2>&1
            fi
        done
    done

    for p in $propagated; do
        for s in applications dbus-1 desktop-directories icons mime polkit-1; do
            if [ -d "$p/share/$s" ]; then
                propagatedUserEnvPkgs+=" $p"
                break
            fi
        done
    done

    runHook postInstall
  '';
}
