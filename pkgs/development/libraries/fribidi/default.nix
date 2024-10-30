{ lib, stdenv
, buildPackages
, fetchurl
, meson
, ninja
, pkg-config
, fixDarwinDylibNames
, python3
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fribidi";
  version = "1.0.15";

  outputs = [ "out" "dev" "devdoc" ];

  # NOTE: Only URL tarball has "Have pre-generated man pages: true", which works-around upstream usage of some rare ancient `c2man` fossil application.
  src = fetchurl {
    url = with finalAttrs; "https://github.com/fribidi/fribidi/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-C7x/9jO/ogiuMtfjac9afSDV0lV6CwZ8mqmLy/mWdYc=";
  };

  postPatch = ''
    patchShebangs test
  '';

  nativeBuildInputs = [ meson ninja pkg-config ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  doCheck = true;
  nativeCheckInputs = [ python3 ];

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/fribidi/fribidi";
    description = "GNU implementation of the Unicode Bidirectional Algorithm (bidi)";
    mainProgram = "fribidi";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    pkgConfigModules = [ "fribidi" ];
  };
})
