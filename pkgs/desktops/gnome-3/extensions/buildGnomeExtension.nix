{ pkgs, lib, stdenv, fetchurl, gnome3, unzip }:

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
    version,
    sha256,
  }:

  stdenv.mkDerivation {
    inherit pname;
    version = builtins.toString version;
    src = fetchurl {
      url = "https://extensions.gnome.org/extension-data/${
          builtins.replaceStrings [ "@" ] [ "" ] uuid
        }.v${builtins.toString version}.shell-extension.zip";
      inherit sha256;
    };
    nativeBuildInputs = [ unzip ];
    buildCommand = ''
      mkdir -p $out/share/gnome-shell/extensions/
      unzip $src -d $out/share/gnome-shell/extensions/${uuid}
    '';
    meta = {
      description = builtins.head (lib.splitString "\n" description);
      longDescription = description;
      homepage = link;
      license = lib.licenses.gpl2Plus; # https://wiki.gnome.org/Projects/GnomeShell/Extensions/Review#Licensing
      maintainers = with lib.maintainers; [ piegames ];
    };
    # Store the extension's UUID, because we might need it at some places
    passthru.extensionUuid = uuid;
  };
in
  lib.makeOverridable buildGnomeExtension
