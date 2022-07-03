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
  version = "1.0.12";

  outputs = [ "out" "devdoc" ];

  # NOTE: Only URL tarball has "Have pre-generated man pages: true", which works-around upstream usage of some rare ancient `c2man` fossil application.
  src = fetchurl {
    url = "https://github.com/fribidi/fribidi/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-DNIz+X/IxnuzrCfOhEDe9dP/rPUWdluRwsxlRJgpNJU=";
  };

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [ meson ninja pkg-config ]
    ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  doCheck = true;
  checkInputs = [ python3 ];

  meta = with lib; {
    homepage = "https://github.com/fribidi/fribidi";
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
