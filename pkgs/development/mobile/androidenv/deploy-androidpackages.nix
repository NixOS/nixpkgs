{stdenv, lib, unzip, mkLicenses}:
{packages, os ? null, nativeBuildInputs ? [], buildInputs ? [], patchesInstructions ? {}, meta ? {}, ...}@args:

let
  extraParams = removeAttrs args [ "packages" "os" "buildInputs" "nativeBuildInputs" "patchesInstructions" ];
  sortedPackages = builtins.sort (x: y: builtins.lessThan x.name y.name) packages;
in
stdenv.mkDerivation ({
  inherit buildInputs;
  pname = lib.concatMapStringsSep "-" (package: package.name) sortedPackages;
  version = lib.concatMapStringsSep "-" (package: package.revision) sortedPackages;
  src = map (package:
    if os != null && builtins.hasAttr os package.archives then package.archives.${os} else package.archives.all
  ) packages;
  nativeBuildInputs = [ unzip ] ++ nativeBuildInputs;
  preferLocalBuild = true;

  unpackPhase = ''
    buildDir=$PWD
    i=0
    for srcArchive in $src; do
      extractedZip="extractedzip-$i"
      i=$((i+1))
      cd "$buildDir"
      mkdir "$extractedZip"
      cd "$extractedZip"
      unpackFile "$srcArchive"
    done
  '';

  installPhase = lib.concatStrings (lib.imap0 (i: package: ''
    cd $buildDir/extractedzip-${toString i}

    # Most Android Zip packages have a root folder, but some don't. We unpack
    # the zip file in a folder and we try to discover whether it has a single root
    # folder. If this is the case, we adjust the current working folder.
    if [ "$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)" -eq 1 ]; then
        cd "$(find . -mindepth 1 -maxdepth 1 -type d)"
    fi
    extractedZip="$PWD"

    packageBaseDir=$out/libexec/android-sdk/${package.path}
    mkdir -p $packageBaseDir
    cd $packageBaseDir
    cp -a $extractedZip/* .
    ${patchesInstructions.${package.name}}
  '') packages);

  # Some executables that have been patched with patchelf may not work any longer after they have been stripped.
  dontStrip = true;
  dontPatchELF = true;
  dontAutoPatchelf = true;

  meta = {
    description = lib.concatMapStringsSep "\n" (package: package.displayName) packages;
  } // meta;
} // extraParams)
