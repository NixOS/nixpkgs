{ lib
, stdenv
, fetchurl
, dpkg
, hip
}:

# This is currently closed-source...
stdenv.mkDerivation (finalAttrs: {
  pname = "hsa-amd-aqlprofile";
  rocmVersion = "5.3.3";
  modVersion = with lib.strings; concatStrings (intersperse "0" (splitString "." finalAttrs.rocmVersion));
  magicVersion = "99";
  ubuntuVersion = "22.04";
  version = finalAttrs.rocmVersion;

  src = fetchurl {
    url = "https://repo.radeon.com/rocm/apt/${finalAttrs.rocmVersion}/pool/main/h/${finalAttrs.pname}/${finalAttrs.pname}_1.0.0.${finalAttrs.modVersion}-${finalAttrs.magicVersion}~${finalAttrs.ubuntuVersion}_amd64.deb";
    hash = "sha256-abTy+5AKbgpM4g2OgUd3LY5oFHJ1raOCwUU0JG6cuZc=";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg -x $src ./
  '';

  installPhase = ''
    mkdir -p $out
    mv opt/rocm-${finalAttrs.rocmVersion}/* $out
    patchelf --set-rpath ${lib.makeLibraryPath [ hip stdenv.cc.cc ]} $out/lib/lib${finalAttrs.pname}64.so.1.0.${finalAttrs.modVersion}
  '';

  meta = with lib; {
    description = "AQLPROFILE library for AMD HSA runtime API extension support";
    homepage = "https://docs.amd.com";
    license = with licenses; [ unfree ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.rocmVersion != hip.version;
  };
})
