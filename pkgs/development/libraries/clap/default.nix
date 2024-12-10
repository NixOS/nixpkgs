{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clap";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap";
    rev = finalAttrs.version;
    hash = "sha256-BNT2yWIlWk8kzhZteh7TaamliwJI+lzWVs/8XCFsuUc=";
  };

  postPatch = ''
    substituteInPlace clap.pc.in \
      --replace '$'"{prefix}/@CMAKE_INSTALL_INCLUDEDIR@" '@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  nativeBuildInputs = [ cmake ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "Clever Audio Plugin API interface headers";
    homepage = "https://cleveraudio.org/";
    pkgConfigModules = [ "clap" ];
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ris ];
  };
})
