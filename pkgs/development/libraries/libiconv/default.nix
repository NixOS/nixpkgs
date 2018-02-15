{ fetchurl, stdenv, lib
, buildPlatform, hostPlatform
}:

# assert !stdenv.isLinux || hostPlatform != buildPlatform; # TODO: improve on cross

stdenv.mkDerivation rec {
  name = "libiconv-${version}";
  version = "1.15";

  src = fetchurl {
    url = "mirror://gnu/libiconv/${name}.tar.gz";
    sha256 = "0y1ij745r4p48mxq84rax40p10ln7fc7m243p8k8sia519i3dxfc";
  };

  postPatch =
    lib.optionalString ((hostPlatform != buildPlatform && hostPlatform.libc == "msvcrt") || stdenv.cc.nativeLibc)
      ''
        sed '/^_GL_WARN_ON_USE (gets/d' -i srclib/stdio.in.h
      '';

  configureFlags =
    lib.optional stdenv.isFreeBSD "--with-pic";

  crossAttrs = {
    # Disable stripping to avoid "libiconv.a: Archive has no index" (MinGW).
    dontStrip = true;
    dontCrossStrip = true;
  };

  meta = {
    description = "An iconv(3) implementation";

    longDescription = ''
      Some programs, like mailers and web browsers, must be able to convert
      between a given text encoding and the user's encoding.  Other programs
      internally store strings in Unicode, to facilitate internal processing,
      and need to convert between internal string representation (Unicode)
      and external string representation (a traditional encoding) when they
      are doing I/O.  GNU libiconv is a conversion library for both kinds of
      applications.
    '';

    homepage = http://www.gnu.org/software/libiconv/;
    license = lib.licenses.lgpl2Plus;

    maintainers = [ ];

    # This library is not needed on GNU platforms.
    hydraPlatforms = with lib.platforms; cygwin ++ darwin ++ freebsd;
  };
}
