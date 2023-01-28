{ stdenv, cmake, fetchFromGitHub, lib }: let
  version = "1.2.2";
in stdenv.mkDerivation {
  name = "stduuid-${version}";

  src = fetchFromGitHub {
    owner = "mariusbancila";
    repo = "stduuid";
    rev = "v${version}";
    hash = "sha256-itx1OF1gmEEMy2tJlkN5dpF6o0dlesecuHYfpJdhf7c=";
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
