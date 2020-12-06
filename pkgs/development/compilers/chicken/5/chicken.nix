{ stdenv, fetchurl, makeWrapper, darwin, bootstrap-chicken ? null }:

let
  version = "5.2.0";
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

  binaryVersion = 11;

  src = fetchurl {
    url = "https://code.call-cc.org/releases/${version}/chicken-${version}.tar.gz";
    sha256 = "1yl0hxm9cirgcp8jgxp6vv29lpswfvaw3zfkh6rsj0vkrv44k4c1";
  };

  setupHook = lib.optional (bootstrap-chicken != null) ./setup-hook.sh;

  # -fno-strict-overflow is not a supported argument in clang on darwin
  hardeningDisable = lib.optionals stdenv.isDarwin ["strictoverflow"];

  makeFlags = [
    "PLATFORM=${platform}" "PREFIX=$(out)"
  ] ++ (lib.optionals stdenv.isDarwin [
    "XCODE_TOOL_PATH=${darwin.binutils.bintools}/bin"
    "C_COMPILER=$(CC)"
  ]);

  buildInputs = [
    makeWrapper
  ] ++ (lib.optionals (bootstrap-chicken != null) [
    bootstrap-chicken
  ]);

  postInstall = ''
    for f in $out/bin/*
    do
      wrapProgram $f \
        --prefix PATH : ${stdenv.cc}/bin
    done
  '';

  # TODO: Assert csi -R files -p '(pathname-file (repository-path))' == binaryVersion

  meta = {
    homepage = "http://www.call-cc.org/";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ corngood ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin; # Maybe other Unix
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
