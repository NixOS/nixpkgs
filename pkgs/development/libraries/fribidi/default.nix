{ lib, stdenv
, buildPackages
, fetchurl
, meson
, ninja
, pkg-config
, fixDarwinDylibNames
, python3
}:

stdenv.mkDerivation rec {
  pname = "fribidi";
  version = "1.0.13";

  outputs = [ "out" "dev" "devdoc" ];

  # NOTE: Only URL tarball has "Have pre-generated man pages: true", which works-around upstream usage of some rare ancient `c2man` fossil application.
  src = fetchurl {
    url = "https://github.com/fribidi/fribidi/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-f6FsgMgb1iL3sZjTE1baE5zDGKY/x3YSF69BMJA/VKI=";
  };

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [ meson ninja pkg-config ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  doCheck = true;
  nativeCheckInputs = [ python3 ];

  meta = with lib; {
    homepage = "https://github.com/fribidi/fribidi";
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
