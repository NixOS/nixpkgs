{ callPackage, fetchurl, dart }:
let
  mkFlutter = opts: callPackage (import ./flutter.nix opts) { };
  getPatches = dir:
    let files = builtins.attrNames (builtins.readDir dir);
    in map (f: dir + ("/" + f)) files;
  version = "2.5.1";
  channel = "stable";
  filename = "flutter_linux_${version}-${channel}.tar.xz";

  # Decouples flutter derivation from dart derivation,
  # use specific dart version to not need to bump dart derivation when bumping flutter.
  dartVersion = "2.14.2";
  dartSourceBase = "https://storage.googleapis.com/dart-archive/channels";
  dartForFlutter = dart.override {
    version = dartVersion;
    sources = {
      "${dartVersion}-x86_64-linux" = fetchurl {
        url = "${dartSourceBase}/stable/release/${dartVersion}/sdk/dartsdk-linux-x64-release.zip";
        sha256 = "1gr2dr683kz0a0k6rcn4jcbxf9fr2xlzi5fcgn1lzrrxvys2lddx";
      };
    };
  };
in {
  mkFlutter = mkFlutter;
  stable = mkFlutter rec {
    inherit version;
    dart = dartForFlutter;
    pname = "flutter";
    src = fetchurl {
      url = "https://storage.googleapis.com/flutter_infra_release/releases/${channel}/linux/${filename}";
      sha256 = "12ycz7iasrc9p9c6zr95l6llyji3za43gsx8cmr2kjfiv23bcrv2";
    };
    patches = getPatches ./patches;
  };
}
