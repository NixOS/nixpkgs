{
  fetchurl,
  lib,
  stdenvNoCC,
  unzip,
  manifestPath ? ./pleroma.json,
}:
let
  # Extract various information from the manifest file.
  manifestSrcs = lib.mapAttrs (
    name: value:
    # We have to use fetchurl instead of fetchzip because we only know the
    # hash of the .zip archive and not the result.
    fetchurl {
      inherit name;
      url = value."src";

      # Convert the provided SHA-256 to SRI.
      hash = lib.convertHash {
        hash = value."src_sha256";
        toHashFormat = "sri";
        hashAlgo = "sha256";
      };
    }
  ) (lib.fromJSON (builtins.readFile manifestPath));
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "volpeon_ink";
  version = "unstable-${lib.substring 0 7 (lib.hashFile "sha256" manifestPath)}";
  srcs = lib.mapAttrsToList (_: value: value) manifestSrcs;

  nativeBuildInputs = [ unzip ];

  outputs = [ "out" ] ++ (lib.mapAttrsToList (name: _: name) manifestSrcs);

  # Make srcs and outputs available as shell variables.
  env = {
    srcPaths = lib.concatStringsSep " " finalAttrs.srcs;
    outputNames = lib.concatStringsSep " " finalAttrs.outputs;
  };

  # We need a manual unpack phase because the default unzip basically works
  # similar to fetchzip's stripRoot=true, which we do not want.
  # Also, some emojis here have overlapping names, which is avoided by this.
  unpackPhase = ''
    runHook preUnpack

    for src in $srcPaths; do
      unzip $src -d $(stripHash "$src")
    done

    runHook postUnpack
  '';

  # Go over every item in outputs and move the respective folder to it.
  # Also, create symlink to $out, which should accumulate all other
  # folders as it's immediate children.
  installPhase = ''
    runHook preInstall

    mkdir $out
    for output in $outputNames; do
      # Handle "out" in the end.
      if [[ "$output" == "out" ]]; then
        continue;
      fi

      # The latter syntax is a nice hack to obtain the environment variable
      # with the name of "output".
      # If $output == "neofox", then ''${!output} == $neofox == <STORE PATH>.
      mv $output ''${!output}
      ln -sf ''${!output} $out/$output
    done

    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;
  meta = {
    description = "Emojis from volpeon.ink";
    license = lib.licenses.cc-by-nc-sa-40;
    homepage = "https://volpeon.ink/emojis";
    maintainers = with lib.maintainers; [ cve ];
    platforms = lib.platforms.all;
  };
})
