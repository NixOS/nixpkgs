{ stdenv, cmake, fetchFromGitHub, lib }: let
  version = "1.2.3";
in stdenv.mkDerivation {
  name = "stduuid-${version}";

  src = fetchFromGitHub {
    owner = "mariusbancila";
    repo = "stduuid";
    rev = "v${version}";
    hash = "sha256-MhpKv+gH3QxiaQMx5ImiQjDGrbKUFaaoBLj5Voh78vg=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "A C++17 cross-platform implementation for UUIDs";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.shlevy ];
    homepage = "https://github.com/mariusbancila/stduuid";
    platforms = lib.platforms.all;
  };
}
