{ stdenv, fetchurl, makeWrapper, bootstrap-chicken ? null }:

let
  version = "4.13.0";
  platform = with stdenv;
    if isDarwin then "macosx"
    else if isCygwin then "cygwin"
    else if (isFreeBSD || isOpenBSD) then "bsd"
    else if isSunOS then "solaris"
    else "linux"; # Should be a sane default
  lib = stdenv.lib;
in
stdenv.mkDerivation {
  pname = "chicken";
  inherit version;

  binaryVersion = 8;

  src = fetchurl {
    url = "https://code.call-cc.org/releases/${version}/chicken-${version}.tar.gz";
    sha256 = "0hvckhi5gfny3mlva6d7y9pmx7cbwvq0r7mk11k3sdiik9hlkmdd";
  };

  setupHook = lib.ifEnable (bootstrap-chicken != null) ./setup-hook.sh;

  buildFlags = [ "PLATFORM=${platform}" "PREFIX=$(out)" "VARDIR=$(out)/var/lib" ];
  installFlags = [ "PLATFORM=${platform}" "PREFIX=$(out)" "VARDIR=$(out)/var/lib" ];

  # We need a bootstrap-chicken to regenerate the c-files after
  # applying a patch to add support for CHICKEN_REPOSITORY_EXTRA
  patches = lib.ifEnable (bootstrap-chicken != null) [
    ./0001-Introduce-CHICKEN_REPOSITORY_EXTRA.patch
  ];

  buildInputs = [
    makeWrapper
  ] ++ (lib.ifEnable (bootstrap-chicken != null) [
    bootstrap-chicken
  ]);

  preBuild = lib.ifEnable (bootstrap-chicken != null) ''
    # Backup the build* files - those are generated from hostname,
    # git-tag, etc. and we don't need/want that
    mkdir -p build-backup
    mv buildid buildbranch buildtag.h build-backup

    # Regenerate eval.c after the patch
    make spotless $buildFlags

    mv build-backup/* .
  '';

  postInstall = ''
    for f in $out/bin/*
    do
      wrapProgram $f \
        --prefix PATH : ${stdenv.cc}/bin
    done
  '';

  # TODO: Assert csi -R files -p '(pathname-file (repository-path))' == binaryVersion

  meta = {
    homepage = http://www.call-cc.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny corngood ];
    platforms = stdenv.lib.platforms.linux; # Maybe other non-darwin Unix
    description = "A portable compiler for the Scheme programming language";
    longDescription = ''
      CHICKEN is a compiler for the Scheme programming language.
      CHICKEN produces portable and efficient C, supports almost all
      of the R5RS Scheme language standard, and includes many
      enhancements and extensions. CHICKEN runs on Linux, macOS,
      Windows, and many Unix flavours.
    '';
  };
}
