{ pkgs, lib, stdenv, fetchzip, nixosTests }:

let

  buildGnomeExtension = {
    # Every gnome extension has a UUID. It's the name of the extension folder once unpacked
    # and can always be found in the metadata.json of every extension.
    uuid,
    name,
    pname,
    description,
    # extensions.gnome.org extension URL
    link,
    # Extension version numbers are integers
    version,
    sha256,
    # Hex-encoded string of JSON bytes
    metadata,
  }:

  stdenv.mkDerivation {
    pname = "gnome-shell-extension-${pname}";
    version = builtins.toString version;
    src = fetchzip {
      url = "https://extensions.gnome.org/extension-data/${
          builtins.replaceStrings [ "@" ] [ "" ] uuid
        }.v${builtins.toString version}.shell-extension.zip";
      inherit sha256;
      stripRoot = false;
      # The download URL may change content over time. This is because the
      # metadata.json is automatically generated, and parts of it can be changed
      # without making a new release. We simply substitute the possibly changed fields
      # with their content from when we last updated, and thus get a deterministic output
      # hash.
      postFetch = ''
        echo "${metadata}" | base64 --decode > $out/metadata.json
      '';
    };
    nativeBuildInputs = with pkgs; [ buildPackages.glib ];
    buildPhase = ''
      runHook preBuild
      if [ -d schemas ]; then
        glib-compile-schemas --strict schemas
      fi
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/gnome-shell/extensions/
      cp -r -T . $out/share/gnome-shell/extensions/${uuid}
      runHook postInstall
    '';
    meta = {
      description = builtins.head (lib.splitString "\n" description);
      longDescription = description;
      homepage = link;
      license = lib.licenses.gpl2Plus; # https://wiki.gnome.org/Projects/GnomeShell/Extensions/Review#Licensing
      maintainers = with lib.maintainers; [ piegames ];
    };
    passthru = {
      extensionPortalSlug = pname;
      # Store the extension's UUID, because we might need it at some places
      extensionUuid = uuid;

      tests = {
        gnome-extensions = nixosTests.gnome-extensions;
      };
    };
  };
in
  lib.makeOverridable buildGnomeExtension
