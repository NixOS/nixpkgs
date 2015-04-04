{ pkgs }:
let

  inherit (builtins) filter head length readFile tail toFile;
  inherit (pkgs) stdenv writeScript crosstool-ng;
  inherit (pkgs.lib) any attrNames attrValues concatStringsSep getVersion
                     hasPrefix hasSuffix last listToAttrs filterAttrs init
                     mapAttrs mapAttrs' mapAttrsToList nameValuePair
                     replaceChars splitString toLower;

  # Random helpers
  stringContains = thing: s: (length (splitString thing s)) != 1;

  stripQuotes = replaceChars ["\"" "'"] ["" ""];

  stripSpace = replaceChars [" " "\t"] ["" ""];

  replaceInString = old: new: s: concatStringsSep new (splitString old s);

  # Returns true if the value v is in the list l
  contains = v: l: any (x: x == v) l;

  # Function to convert a config file to a set
  cfgToSet = cfg: let
    cfgList = splitString "\n" (readFile cfg);
    cfgFiltered = filter (s: !(hasPrefix "#" s) && (stripSpace s) != "") cfgList;
    cfgAttrList = map (s:
      let eqSplit = splitString "=" s;
      # Accounts for equal signs in the value
      in nameValuePair (head eqSplit) (concatStringsSep "=" (tail eqSplit))
    ) cfgFiltered;
  in listToAttrs cfgAttrList;

  # Convert from a set to a config string
  setToCfg = set: concatStringsSep "\n" (mapAttrsToList (n: v: n + "=" + v) set);

  # Create a set of dependencies to their versions from the configuration set
  parseVersions = set:
    if (any (s: hasSuffix "CUSTOM_LOCATION" s || stringContains "LINARO" s) (attrNames set))
    || (any (s: stringContains "linaro" s) (attrValues set))
      then throw "Custom source locations and linaro versions are unsupported."
      else mapAttrs' (n: v:
        let k = toLower (head (tail (splitString "_" n)));
        in nameValuePair
          (stripQuotes (
            if k == "kernel" then set.CT_KERNEL
            else if k == "cc" then set.CT_CC
            else if k == "libc" then set.CT_LIBC
            else k))
          (stripQuotes v)
        )
        (filterAttrs (n: v: hasSuffix "_VERSION" n && (length (splitString "_" n) == 3)) set);

  # Returns a map of package names and versions to fetchurl derivations
  sourcesMap = import ./package-map.nix { inherit pkgs; };

  # Supports finding the same extensions supported by ct-ng's extract function
  getExt = s: let
    l = splitString "." s;
    last1 = last l;
    last2 = last (init l);
  in if contains last1 [ "tgz" "tar" "zip" ] then last1
     else if last2 == "tar" && contains last1 [ "xz" "lzma" "bz2" "gz" ] then "tar." + last1
     else throw "Unknown file extension.";
in {
  mkCrossToolchain = { name, config, toolchainPrefix ? "", additionalInputs ? [] }:
  let
    # Set that maps config names to config values
    cfgSet = cfgToSet config;

    # List of dependencies' calculated parameters
    depInfo = mapAttrs (n: v: rec {
      srcTar = sourcesMap."${n}"."${v}".out;
      base = "${n}-${v}";
      ext = getExt srcTar;
      full = base + "." + ext;
    }) (parseVersions cfgSet);

    altHomeDir = "dummy_home";
    localTarDir = "tars";
    buildDir = "build";

  in stdenv.mkDerivation rec {
    inherit name;

    buildInputs = [ crosstool-ng ] ++ additionalInputs;

    prefix = toolchainPrefix;

    builder = writeScript "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out

      # Where ct-ng might put stuff
      mkdir -p ./${altHomeDir}
      # Where tarballs go so ct-ng doesn't fetch them from the internet
      mkdir -p ./${localTarDir}
      # Where extracted sources go so we can patch what we need to
      mkdir -p ./${buildDir}/src

      cp ${generatedConfig} .config
      # Fix out directory
      substituteAllInPlace .config

      # Copy tarballs from nix store to tarball directory
      ${concatStringsSep "\n" (
        map (d: "cp ${d.srcTar} ./${localTarDir}/${d.full}") (attrValues depInfo)
      )}

      ct-ng build
    '';

    generatedConfig = toFile (name + ".config") (setToCfg (
      # In the configuration values, replace all instances of ${HOME} with
      # ${CT_TOP_DIR}/dummy_home and override parameters for nix builds

      (mapAttrs (n: v: replaceInString "\${HOME}" "\${CT_TOP_DIR}/${altHomeDir}" v) cfgSet) // {
        # These overrides are required for all configs because of how nix
        # builds and stores build products.

        CT_WORK_DIR = "\"\${CT_TOP_DIR}/${buildDir}\"";

        CT_TARGET_ALIAS = "\"${toolchainPrefix}\"";

        # Install to the correct output directory.
        CT_PREFIX_DIR = "\"@out@\"";

        # This option makes the install directory read-only but nix will take
        # care of that for us. Build fails without this since ct-ng doesn't have
        # the permissions to perform this.
        CT_INSTALL_DIR_RO = "n";

        # This is unnecessary because we get a clean environment with nix.
        CT_RM_RF_PREFIX_DIR = "n";

        # Don't try to download anything
        CT_FORBID_DOWNLOAD = "y";

        # No need to save tarballs because they are in the nix store.
        CT_SAVE_TARBALLS = "n";

        # Location where we place tarballs from the nix store.
        CT_LOCAL_TARBALLS_DIR = "\"\${CT_TOP_DIR}/${localTarDir}\"";

        # Support as many formats as possible since we don't know what format
        # of source archive we'll be getting from existing nix expressions
        CT_CONFIGURE_has_lzma = "y";
        CT_CONFIGURE_has_xz = "y";
      }
    ));
  };
}
