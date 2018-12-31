{ stdenv, fetchurl, makeWrapper, bootstrap-chicken ? null }:

let
  version = "5.0.0";
  platform = with stdenv;
    if isDarwin then "macosx"
    else if isCygwin then "cygwin"
    else if (isFreeBSD || isOpenBSD) then "bsd"
    else if isSunOS then "solaris"
    else "linux"; # Should be a sane default
  lib = stdenv.lib;
in
stdenv.mkDerivation {
  name = "chicken-${version}";

  binaryVersion = 9;

  src = fetchurl {
    url = "https://code.call-cc.org/releases/${version}/chicken-${version}.tar.gz";
    sha256 = "15b5yrzfa8aimzba79x7v6y282f898rxqxfxrr446sjx9jwlpfd8";
  };

  setupHook = lib.ifEnable (bootstrap-chicken != null) ./setup-hook.sh;

  buildFlags = "PLATFORM=${platform} PREFIX=$(out) VARDIR=$(out)/var/lib";
  installFlags = "PLATFORM=${platform} PREFIX=$(out) VARDIR=$(out)/var/lib";

  buildInputs = [
    makeWrapper
  ] ++ (lib.ifEnable (bootstrap-chicken != null) [
    bootstrap-chicken
  ]);

  postInstall = ''
    for f in $out/bin/*
    do
      wrapProgram $f \
        --prefix PATH : ${stdenv.cc}/bin
    done

    mv $out/var/lib/chicken $out/lib
    rmdir $out/var/lib
    rmdir $out/var
  '';

  # TODO: Assert csi -R files -p '(pathname-file (repository-path))' == binaryVersion

  meta = {
    homepage = http://www.call-cc.org/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
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
