{
  stdenvNoCC,
  hugs,
  makeWrapper,
  microhs-src,
}:

stdenvNoCC.mkDerivation {
  pname = "microhs";
  version = "${microhs-src.version}-hugs";

  inherit (microhs-src)
    src
    patches
    postPatch
    meta
    ;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/microhs-hugs"
    s="$out/share/microhs-hugs/src"
    cp -r . "$s"

    makeWrapper ${hugs}/bin/runhugs "$out/bin/mhs" \
      --add-flags "'+P$s/hugs:$s/src:$s/paths:{Hugs}/packages/*:hugs/obj' -98 +o +w -h100m '$s/hugs/Main.hs'"

    runHook postInstall
  '';

  passthru = {
    isMhs = true;
    usesHugs = true;
  };
}
