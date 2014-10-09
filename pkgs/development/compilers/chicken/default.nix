{ stdenv, fetchurl, bootstrap-chicken ? null }:

let
  version = "4.9.0.1";
  platform = with stdenv;
    if isDarwin then "macosx"
    else if isCygwin then "cygwin"
    else if isBSD then "bsd"
    else if isSunOS then "solaris"
    else "linux";               # Should be a sane default
in
stdenv.mkDerivation {
  name = "chicken-${version}";

  src = fetchurl {
    url = "http://code.call-cc.org/releases/4.9.0/chicken-${version}.tar.gz";
    sha256 = "0598mar1qswfd8hva9nqs88zjn02lzkqd8fzdd21dz1nki1prpq4";
  };

  buildFlags = "PLATFORM=${platform} PREFIX=$(out) VARDIR=$(out)/var/lib";
  installFlags = "PLATFORM=${platform} PREFIX=$(out) VARDIR=$(out)/var/lib";

  # We need a bootstrap-chicken to regenerate the c-files after
  # applying a patch to add support for CHICKEN_REPOSITORY_EXTRA
  patches = stdenv.lib.ifEnable (bootstrap-chicken != null) [
    ./0001-Introduce-CHICKEN_REPOSITORY_EXTRA.patch
  ];

  buildInputs = stdenv.lib.ifEnable (bootstrap-chicken != null) [
    bootstrap-chicken
  ];

  preBuild = stdenv.lib.ifEnable (bootstrap-chicken != null) ''
    # Backup the build* files - those are generated from hostname,
    # git-tag, etc. and we don't need/want that
    mkdir -p build-backup
    mv buildid buildbranch buildtag.h build-backup

    # Regenerate eval.c after the patch
    make spotless $buildFlags

    mv build-backup/* .
  '';

  meta = {
    homepage = http://www.call-cc.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = with stdenv.lib.platforms; allBut darwin;
    description = "A portable compiler for the Scheme programming language";
    longDescription = ''
      CHICKEN is a compiler for the Scheme programming language.
      CHICKEN produces portable and efficient C, supports almost all
      of the R5RS Scheme language standard, and includes many
      enhancements and extensions. CHICKEN runs on Linux, MacOS X,
      Windows, and many Unix flavours.
    '';
  };
}
