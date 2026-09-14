{
  fetchurl,
  lib,
  libarchive,
  stdenv,
  unshield,
  ut2004Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "ut2004-data";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    libarchive
    unshield
  ];

  unpackPhase = ''
    mkdir cabs
    bsdtar -xvf "${ut2004Packages.image}/ut2004.iso" -C cabs --strip-components 1 'Disk?/*.cab' 'Disk?/*.hdr'
    unshield -d data x cabs/data1.cab
  '';

  installPhase = ''
    mv data $out
  '';

  meta = {
    description = "Unreal Tournament 2004 CD content provided by OldUnreal";
    homepage = "https://oldunreal.com/downloads/ut2004/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ corps-fini ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
