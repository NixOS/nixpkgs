{
  lib,
  stdenvNoCC,
  hugs,
  makeWrapper,
  microhs-src,
  runtimeShell,
}:

stdenvNoCC.mkDerivation {
  pname = "microhs";
  version = "${microhs-src.version}-hugs";

  inherit (microhs-src) src;

  patches = [ patches/hugs.patch ];

  nativeBuildInputs = [ makeWrapper ];

  # buildPhase by default runs make, which we don't want
  buildPhase = ''
    runHook preBuild
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/microhs-hugs"
    s="$out/share/microhs-hugs/src"
    cp -r . "$s"

    makeWrapper ${hugs}/bin/runhugs "$out/bin/mhs" \
      --add-flags "'+P$s/hugs:$s/src:$s/paths:{Hugs}/packages/*:hugs/obj' -98 +o +w -h100m '$s/hugs/Main.hs'"

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
