{ lib, stdenv, fetchurl

, mouseSupport ? false
, unicode ? true

, gpm

# Extra Options
, abiVersion ? "5"
}:

stdenv.mkDerivation rec {
  name = "ncurses-5.9";

  src = fetchurl {
    url = "mirror://gnu/ncurses/${name}.tar.gz";
    sha256 = "0fsn7xis81za62afan0vvm38bvgzg5wfmv1m86flqcj0nj7jjilh";
  };

  # gcc-5.patch should be removed after 5.9
  patches = [ ./clang.patch ./gcc-5.patch ];

  configureFlags = [
    "--with-shared"
    "--without-debug"
    "--enable-pc-files"
    "--enable-symlinks"
  ] ++ lib.optional unicode "--enable-widec";

  # Only the C compiler, and explicitly not C++ compiler needs this flag on solaris:
  CFLAGS = lib.optionalString stdenv.isSunOS "-D_XOPEN_SOURCE_EXTENDED";

  buildInputs = lib.optional (mouseSupport && stdenv.isLinux) gpm;

  preConfigure = ''
    configureFlagsArray+=("--includedir=$out/include")
    export PKG_CONFIG_LIBDIR="$out/lib/pkgconfig"
    mkdir -p "$PKG_CONFIG_LIBDIR"
  ''
  + lib.optionalString stdenv.isSunOS ''
    sed -i -e '/-D__EXTENSIONS__/ s/-D_XOPEN_SOURCE=\$cf_XOPEN_SOURCE//' \
           -e '/CPPFLAGS="$CPPFLAGS/s/ -D_XOPEN_SOURCE_EXTENDED//' \
        configure
    CFLAGS=-D_XOPEN_SOURCE_EXTENDED
  '' + lib.optionalString stdenv.isCygwin ''
    sed -i -e 's,LIB_SUFFIX="t,LIB_SUFFIX=",' configure
  '';

  selfNativeBuildInput = true;

  enableParallelBuilding = true;

  doCheck = false;

  # When building a wide-character (Unicode) build, create backward
  # compatibility links from the the "normal" libraries to the
  # wide-character libraries (e.g. libncurses.so to libncursesw.so).
  postInstall = ''
    # Determine what suffixes our libraries have
    suffix="$(awk -F': ' 'f{print $3; f=0} /default library suffix/{f=1}' config.log)"
    libs="$(ls $out/lib/pkgconfig | tr ' ' '\n' | sed "s,\(.*\)$suffix\.pc,\1,g")"
    suffixes="$(echo "$suffix" | awk '{for (i=1; i < length($0); i++) {x=substr($0, i+1, length($0)-i); print x}}')"

    # Get the path to the config util
    cfg=$(basename $out/bin/ncurses*-config)

    # symlink the full suffixed include directory
    ln -svf . $out/include/ncurses$suffix

    for newsuffix in $suffixes ""; do
      # Create a non-abi versioned config util links
      ln -svf $cfg $out/bin/ncurses$newsuffix-config

      # Allow for end users who #include <ncurses?w/*.h>
      ln -svf . $out/include/ncurses$newsuffix

      for lib in $libs; do
        for dylibtype in so dll dylib; do
          if [ -e "$out/lib/lib''${lib}$suffix.$dylibtype" ]; then
            ln -svf lib''${lib}$suffix.$dylibtype $out/lib/lib$lib$newsuffix.$dylibtype
            ln -svf lib''${lib}$suffix.$dylibtype.${abiVersion} $out/lib/lib$lib$newsuffix.$dylibtype.${abiVersion}
          fi
        done
        for statictype in a dll.a la; do
          if [ -e "$out/lib/lib''${lib}$suffix.$statictype" ]; then
            ln -svf lib''${lib}$suffix.$statictype $out/lib/lib$lib$newsuffix.$statictype
          fi
        done
        ln -svf ''${lib}$suffix.pc $out/lib/pkgconfig/$lib$newsuffix.pc
      done
    done
  '';

  preFixup = ''
    rm $out/lib/*.a
  '';

  meta = {
    description = "Free software emulation of curses in SVR4 and more";

    longDescription = ''
      The Ncurses (new curses) library is a free software emulation of
      curses in System V Release 4.0, and more.  It uses Terminfo
      format, supports pads and color and multiple highlights and
      forms characters and function-key mapping, and has all the other
      SYSV-curses enhancements over BSD Curses.

      The ncurses code was developed under GNU/Linux.  It has been in
      use for some time with OpenBSD as the system curses library, and
      on FreeBSD and NetBSD as an external package.  It should port
      easily to any ANSI/POSIX-conforming UNIX.  It has even been
      ported to OS/2 Warp!
    '';

    homepage = http://www.gnu.org/software/ncurses/;

    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.wkennington ];
  };

  passthru = {
    ldflags = "-lncurses";
    inherit unicode abiVersion;
  };
}
