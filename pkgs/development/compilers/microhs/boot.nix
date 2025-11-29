{
  lib,
  stdenvNoCC,
  hugs,
  microhs-src,
  runtimeShell,
}:

stdenvNoCC.mkDerivation {
  pname = "microhs";
  version = "${microhs-src.version}-hugs";

  inherit (microhs-src) src;

  patches = [ patches/hugs.patch ];

  buildPhase = ''
    runHook preBuild
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/microhs-hugs"
    cp -r . "$out/share/microhs-hugs/src"

    {
      printf ${lib.escapeShellArg ''
        #!${runtimeShell}
        s='%s/share/microhs-hugs/src'
        exec ${hugs}/bin/runhugs "+P$s/hugs:$s/src:$s/paths:{Hugs}/packages/*:hugs/obj" -98 +o +w -h100m "$s/hugs/Main.hs" "$@"
      ''} "$out"
    } > "$out/bin/mhs"
    chmod +x $out/bin/mhs

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/mhs --version
  '';

  passthru = {
    isMhs = true;
    isHugs = true;
  };
}
