{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "5.1";
  branch = version;
  sha256 = "sha256-MrVvsBzpDUUpWK4l6RyVZKv0ntVFPBJ77CPGPlMKqPo=";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];

  # Newly introduced IPFS support in ffmpeg 5.1 relies on untrusted third
  # party services, leading to consent and privacy issues. See upstream
  # discussion for more information:
  # https://ffmpeg.org/pipermail/ffmpeg-devel/2022-August/299924.html
  patches = [ ./ipfs-remove-default-gateway.patch ];
} // args)
