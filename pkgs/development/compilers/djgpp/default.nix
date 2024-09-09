{ bison
, buildPackages
, curl
, fetchFromGitHub
, fetchurl
, file
, flex
, targetArchitecture ? "i586"
, lib
, makeWrapper
, perl
, stdenv
, texinfo
, unzip
, which }:

let
  s = import ./sources.nix { inherit fetchurl fetchFromGitHub; };
in
assert lib.elem targetArchitecture [ "i586" "i686" ];
stdenv.mkDerivation rec {
  pname = "djgpp";
  version = s.gccVersion;
  src = s.src;

  patchPhase = ''
    runHook prePatch
    for f in "build-djgpp.sh" "script/${version}" "setenv/copyfile.sh"; do
      substituteInPlace "$f" --replace '/usr/bin/env' '${buildPackages.coreutils}/bin/env'
    done
  ''
  # i686 patches from https://github.com/andrewwutw/build-djgpp/issues/45#issuecomment-1484010755
  # The build script unpacks some files so we can't patch ahead of time, instead patch the script
  # to patch after it extracts

  + lib.optionalString (targetArchitecture == "i686") ''
    sed -i 's/i586/i686/g' setenv/setenv script/${version}
    sed -i '/Building DXE tools./a sed -i "s/i586/i686/g" src/makefile.def src/dxe/makefile.dxe' script/${version}
  ''
  + ''
    runHook postPatch
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    bison
    curl
    file
    flex
    perl
    texinfo
    unzip
    which
  ];

  hardeningDisable = [ "format" ];

  # stripping breaks static libs, causing this when you attempt to compile a binary:
  # error adding symbols: Archive has no index; run ranlib to add one
  dontStrip = true;

  buildPhase = ''
    runHook preBuild
    mkdir download; pushd download
    ln -s "${s.autoconf}"   "${s.autoconf.name}"
    ln -s "${s.automake}"   "${s.automake.name}"
    ln -s "${s.binutils}"   "${s.binutils.name}"
    ln -s "${s.djcrossgcc}" "${s.djcrossgcc.name}"
    ln -s "${s.djcrx}"      "${s.djcrx.name}"
    ln -s "${s.djdev}"      "${s.djdev.name}"
    ln -s "${s.djlsr}"      "${s.djlsr.name}"
    ln -s "${s.gcc}"        "${s.gcc.name}"
    ln -s "${s.gmp}"        "${s.gmp.name}"
    ln -s "${s.mpc}"        "${s.mpc.name}"
    ln -s "${s.mpfr}"       "${s.mpfr.name}"
    popd
    DJGPP_PREFIX=$out ./build-djgpp.sh ${version}
    runHook postBuild
  '';

  postInstall = ''
    for f in dxegen dxe3gen dxe3res exe2coff stubify; do
      cp -v "$out/${targetArchitecture}-pc-msdosdjgpp/bin/$f" "$out/bin"
    done

    for f in dxegen dxe3gen; do
      wrapProgram $out/bin/$f --set DJDIR $out
    done
  '';

  meta = {
    description = "Complete 32-bit GNU-based development system for Intel x86 PCs running DOS";
    homepage = "https://www.delorie.com/djgpp/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
