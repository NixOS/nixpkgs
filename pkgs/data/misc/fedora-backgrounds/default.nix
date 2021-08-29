{ callPackage, lib, fetchurl }:

let
  fedoraBackground = callPackage ./generic.nix { };
in {
  f32 = fedoraBackground rec {
    version = "32.2.2";
    src = fetchurl {
      url = "https://github.com/fedoradesign/backgrounds/releases/download/v${version}/f${lib.versions.major version}-backgrounds-${version}.tar.xz";
      hash = "sha256-1F75aae7Jj7M2IPn/vWKcUF+O5mZ0Yey7hWuFj/4Fhg=";
    };
  };

  f33 = fedoraBackground rec {
    version = "33.0.7";
    src = fetchurl {
      url = "https://github.com/fedoradesign/backgrounds/releases/download/v${version}/f${lib.versions.major version}-backgrounds-${version}.tar.xz";
      hash = "sha256-lAn5diEYebCo2ZJCOn9rD87rOasUU0qnSOr0EnZKW4o=";
    };
    # Fix broken symlinks in the Xfce background directory.
    patches = [ ./f33-fix-xfce-path.patch ];
  };

  f34 = fedoraBackground rec {
    version = "34.0.1";
    src = fetchurl {
      url = "https://github.com/fedoradesign/backgrounds/releases/download/v${version}/f${lib.versions.major version}-backgrounds-${version}.tar.xz";
      hash = "sha256-0gotgQ4N0yE8WZbsu7B3jmUIZrycbqjEMxZl01JcJj4=";
    };
    # Fix broken symlinks in the Xfce background directory.
    patches = [ ./f34-fix-xfce-path.patch ];
  };

}
