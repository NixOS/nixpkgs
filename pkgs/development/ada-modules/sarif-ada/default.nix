{
  lib,
  stdenv,
  fetchFromGitHub,
  gprbuild,
  gnat,
  vss-extra,
  vss-text,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sarif-ada";
  version = "26.0.0-unstable-2025-10-21";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "sarif-ada";
    rev = "7201a4b1993cafe9c3c44eeb07be81ae3bdd9342";
    hash = "sha256-0p3d4hZ8OFyQIMFAPjEWAd6mAOaRKwiefwqUkWyx950=";
  };

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  propagatedBuildInputs = [
    vss-extra
    vss-text
  ];

  env = {
    PREFIX = placeholder "out";
    GPRDIR = "${finalAttrs.env.PREFIX}/share/gpr";
    LIBDIR = "${finalAttrs.env.PREFIX}/lib";
    BINDIR = "${finalAttrs.env.PREFIX}/bin";
    INSTALL_PROJECT_DIR = finalAttrs.env.GPRDIR;
    INSTALL_INCLUDE_DIR = "${finalAttrs.env.PREFIX}/include/sarif_ada";
    INSTALL_EXEC_DIR = finalAttrs.env.BINDIR;
    INSTALL_LIBRARY_DIR = finalAttrs.env.LIBDIR;
    INSTALL_ALI_DIR = "${finalAttrs.env.INSTALL_LIBRARY_DIR}/sarif_ada";
  };

  # Based on the vss-text makefile
  # Use this over the built in makefile to allow building shared libraries
  buildPhase = ''
    runHook preBuild

    gprbuild -p -j$NIX_BUILD_CORES $GPRFLAGS -XSARIF_BUILD_PROFILE=release \
      -XSARIF_ADA_LIBRARY_TYPE=static -XVSS_LIBRARY_TYPE=static sarif_ada.gpr
    gprbuild -p -j$NIX_BUILD_CORES $GPRFLAGS -XSARIF_BUILD_PROFILE=validation \
      -XSARIF_ADA_LIBRARY_TYPE=static -XVSS_LIBRARY_TYPE=static sarif_ada.gpr
  ''
  + lib.optionalString enableShared ''
    gprbuild -p -j$NIX_BUILD_CORES $GPRFLAGS -XSARIF_BUILD_PROFILE=release \
      -XSARIF_ADA_LIBRARY_TYPE=static-pic -XVSS_LIBRARY_TYPE=static-pic sarif_ada.gpr
    gprbuild -p -j$NIX_BUILD_CORES $GPRFLAGS -XSARIF_BUILD_PROFILE=validation \
      -XSARIF_ADA_LIBRARY_TYPE=static-pic -XVSS_LIBRARY_TYPE=static-pic sarif_ada.gpr
    gprbuild -p -j$NIX_BUILD_CORES $GPRFLAGS -XSARIF_BUILD_PROFILE=release \
      -XSARIF_ADA_LIBRARY_TYPE=relocatable -XVSS_LIBRARY_TYPE=relocatable sarif_ada.gpr
    gprbuild -p -j$NIX_BUILD_CORES $GPRFLAGS -XSARIF_BUILD_PROFILE=validation \
      -XSARIF_ADA_LIBRARY_TYPE=relocatable -XVSS_LIBRARY_TYPE=relocatable sarif_ada.gpr
  ''
  + ''

    runHook postBuild
  '';

  # Makefile has no install target
  installPhase = ''
    runHook preInstall

    gprinstall $GPRFLAGS -XSARIF_BUILD_PROFILE=release \
      -XSARIF_ADA_LIBRARY_TYPE=static -XVSS_LIBRARY_TYPE=static --build-name=static \
      --build-var=LIBRARY_TYPE --build-var=SARIF_ADA_LIBRARY_TYPE \
      --prefix=$PREFIX --exec-subdir=$INSTALL_EXEC_DIR \
      --lib-subdir=$INSTALL_ALI_DIR/static --project-subdir=$INSTALL_PROJECT_DIR \
      --link-lib-subdir=$INSTALL_LIBRARY_DIR --sources-subdir=$INSTALL_INCLUDE_DIR \
      -f -p -P sarif_ada.gpr --install-name=sarif_ada
  ''
  + lib.optionalString enableShared ''
    gprinstall $GPRFLAGS -XSARIF_BUILD_PROFILE=release \
      -XSARIF_ADA_LIBRARY_TYPE=static-pic -XVSS_LIBRARY_TYPE=static-pic --build-name=static-pic \
      --build-var=LIBRARY_TYPE --build-var=SARIF_ADA_LIBRARY_TYPE \
      --prefix=$PREFIX --exec-subdir=$INSTALL_EXEC_DIR \
      --lib-subdir=$INSTALL_ALI_DIR/static-pic --project-subdir=$INSTALL_PROJECT_DIR \
      --link-lib-subdir=$INSTALL_LIBRARY_DIR --sources-subdir=$INSTALL_INCLUDE_DIR \
      -f -p -P sarif_ada.gpr --install-name=sarif_ada
    gprinstall $GPRFLAGS -XSARIF_BUILD_PROFILE=release \
      -XSARIF_ADA_LIBRARY_TYPE=relocatable -XVSS_LIBRARY_TYPE=relocatable --build-name=relocatable \
      --build-var=LIBRARY_TYPE --build-var=SARIF_ADA_LIBRARY_TYPE \
      --prefix=$PREFIX --exec-subdir=$INSTALL_EXEC_DIR \
      --lib-subdir=$INSTALL_ALI_DIR/relocatable --project-subdir=$INSTALL_PROJECT_DIR \
      --link-lib-subdir=$INSTALL_LIBRARY_DIR --sources-subdir=$INSTALL_INCLUDE_DIR \
      -f -p -P sarif_ada.gpr --install-name=sarif_ada
  ''
  + ''

    runHook postInstall
  '';

  meta = {
    description = "An Ada library for parsing and producing SARIF reports";
    homepage = "https://github.com/AdaCore/sarif-ada";
    license = lib.licenses.llvm-exception;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
