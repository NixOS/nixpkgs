{stdenv, unzip}:
{package, os ? null, buildInputs ? [], patchInstructions ? "", meta ? {}, ...}@args:

let
  extraParams = removeAttrs args [ "package" "os" "buildInputs" "patchInstructions" ];
in
stdenv.mkDerivation ({
  name = package.name + "-" + package.revision;
  src = if os != null && builtins.hasAttr os package.archives then package.archives.${os} else package.archives.all;
  buildInputs = [ unzip ] ++ buildInputs;

  # Most Android Zip packages have a root folder, but some don't. We unpack
  # the zip file in a folder and we try to discover whether it has a single root
  # folder. If this is the case, we adjust the current working folder.
  unpackPhase = ''
    mkdir extractedzip
    cd extractedzip
    unpackFile "$src"
    if [ "$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)" -eq 1 ]
    then
        cd "$(find . -mindepth 1 -maxdepth 1 -type d)"
    fi
    sourceRoot="$PWD"
  '';

  installPhase = ''
    packageBaseDir=$out/libexec/android-sdk/${package.path}
    mkdir -p $packageBaseDir
    cd $packageBaseDir
    cp -av $sourceRoot/* .
    ${patchInstructions}
  '';

  # We never attempt to strip. This is not required since we're doing binary
  # deployments. Moreover, some executables that have been patched with patchelf
  # may not work any longer after they have been stripped.
  dontStrip = true;
  dontPatchELF = true;
  dontAutoPatchelf = true;

  meta = {
    description = package.displayName;
  } // meta;
} // extraParams)
