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

  f35 = fedoraBackground rec {
    version = "35.0.1";
    src = fetchurl {
      url = "https://github.com/fedoradesign/backgrounds/releases/download/v${version}/f${lib.versions.major version}-backgrounds-${version}.tar.xz";
      hash = "sha256-7t78sQ0BIkzgJ+phO55Bomyz02d8Vx1LAtSkjX8ppgE=";
    };
    # Fix broken symlinks in the Xfce background directory.
    patches = [ ./f35-fix-xfce-path.patch ];
  };

  f36 = fedoraBackground rec {
    version = "36.1.2";
    src = fetchurl {
      url = "https://github.com/fedoradesign/backgrounds/releases/download/v${version}/f${lib.versions.major version}-backgrounds-${version}.tar.xz";
      hash = "sha256-DZr1YHltojl02X/3sErqB/29JBDy/7lDZKnHD+KouHc=";
    };
  };

  f37 = fedoraBackground rec {
    version = "37.0.5";
    src = fetchurl {
      url = "https://github.com/fedoradesign/backgrounds/releases/download/v${version}/f${lib.versions.major version}-backgrounds-${version}.tar.xz";
      hash = "sha256-bkjxJDDU0dZURKIK1sd+EOnPt9vvJ5HqHkc6OhPBBn0=";
    };
  };

  f38 = fedoraBackground rec {
    version = "38.1.1";
    src = fetchurl {
      url = "https://github.com/fedoradesign/backgrounds/releases/download/v${version}/f${lib.versions.major version}-backgrounds-${version}.tar.xz";
      hash = "sha256-YSNP7GhS5i5mJDsa4UwsXJm8Tv43r9JxrcYIbkXQKm4=";
    };
  };
}
