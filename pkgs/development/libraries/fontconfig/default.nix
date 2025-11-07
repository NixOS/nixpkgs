{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  python3,
  freetype,
  expat,
  libxslt,
  gperf,
  dejavu_fonts,
  autoreconfHook,
  versionCheckHook,
  testers,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fontconfig";
  version = "2.17.1";

  outputs = [
    "bin"
    "dev"
    "lib"
    "out"
  ]; # $out contains all the config

  # GitLab repositrory does not include pre-generated man pages.
  # ref: https://github.com/NixOS/nixpkgs/pull/401037#discussion_r2055430206
  src = fetchurl {
    url = "https://gitlab.freedesktop.org/api/v4/projects/890/packages/generic/fontconfig/${finalAttrs.version}/fontconfig-${finalAttrs.version}.tar.xz";
    hash = "sha256-n1yuk/T//B+8Ba6ZzfxwjNYN/WYS/8BRKCcCXAJvpUE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gperf
    libxslt
    pkg-config
    python3
  ];

  buildInputs = [
    expat
  ];

  propagatedBuildInputs = [
    freetype
  ];

  postPatch = ''
    # Requires networking.
    sed -i '/check_PROGRAMS += test-crbug1004254/d' test/Makefile.am

    # Test causes error without patch shebangs.
    patchShebangs doc/check-whitespace-in-args.py \
      doc/check-missing-doc.py
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-arch=${stdenv.hostPlatform.parsed.cpu.name}"
    "--with-cache-dir=/var/cache/fontconfig" # otherwise the fallback is in $out/
    # just <1MB; this is what you get when loading config fails for some reason
    "--with-default-fonts=${dejavu_fonts.minimal}"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--with-arch=${stdenv.hostPlatform.parsed.cpu.name}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  installFlags = [
    # Don't try to write to /var/cache/fontconfig at install time.
    "fc_cachedir=$(TMPDIR)/dummy"
    "RUN_FC_CACHE_TEST=false"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    cd "$out/etc/fonts"
    xsltproc --stringparam fontDirectories "${dejavu_fonts.minimal}" \
      --stringparam includes /etc/fonts/conf.d \
      --path $out/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} $out/etc/fonts/fonts.conf \
      > fonts.conf.tmp
    mv fonts.conf.tmp $out/etc/fonts/fonts.conf
    # We don't keep section 3 of the manpages, as they are quite large and
    # probably not so useful.
    rm -r $bin/share/man/man3
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "bin"}/bin/fc-list";
  versionCheckProgramArg = "--version";

  installCheckPhase = ''
    runHook preInstallCheck

    [ -d "$bin/share/man/man1" ]
    [ -d "$bin/share/man/man5" ]
    echo "man pages exist"

    runHook postInstallCheck
  '';

  passthru = {
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };

    updateScript = gitUpdater {
      url = "https://gitlab.freedesktop.org/fontconfig/fontconfig.git";
    };
  };

  meta = with lib; {
    description = "Library for font customization and configuration";
    homepage = "http://fontconfig.org/";
    license = licenses.bsd2; # custom but very bsd-like
    platforms = platforms.all;
    teams = [ teams.freedesktop ];
    pkgConfigModules = [ "fontconfig" ];
  };
})
