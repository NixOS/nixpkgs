{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (rec {
  version = "5.0";
  branch = version;
  sha256 = "1ndy6a2bhl6nvz9grmcaakh4xi0vss455466s47l6qy7na6hn4y0";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];

  patches = [ ./0001-fate-ffmpeg-add-missing-samples-dependency-to-fate-s.patch ];
} // args)
