{ stdenv
, lib
, fetchurl
, pkg-config
, python3
, freetype
, expat
, libxslt
, gperf
, dejavu_fonts
, autoreconfHook
, CoreFoundation
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fontconfig";
  version = "2.15.0";

  outputs = [ "bin" "dev" "lib" "out" ]; # $out contains all the config

  src = fetchurl {
    url = with finalAttrs; "https://www.freedesktop.org/software/fontconfig/release/${pname}-${version}.tar.xz";
    hash = "sha256-Y6BljQ4G4PqIYQZFK1jvBPIfWCAuoCqUw53g0zNdfA4=";
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
  ] ++ lib.optional stdenv.isDarwin CoreFoundation;

  propagatedBuildInputs = [
    freetype
  ];

  postPatch = ''
    # Requires networking.
    sed -i '/check_PROGRAMS += test-crbug1004254/d' test/Makefile.am
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-arch=${stdenv.hostPlatform.parsed.cpu.name}"
    "--with-cache-dir=/var/cache/fontconfig" # otherwise the fallback is in $out/
    # just <1MB; this is what you get when loading config fails for some reason
    "--with-default-fonts=${dejavu_fonts.minimal}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
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

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Library for font customization and configuration";
    homepage = "http://fontconfig.org/";
    license = licenses.bsd2; # custom but very bsd-like
    platforms = platforms.all;
    maintainers = with maintainers; teams.freedesktop.members ++ [ ];
    pkgConfigModules = [ "fontconfig" ];
  };
})
