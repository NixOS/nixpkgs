/* This function builds just the `lib/locale/locale-archive' file from
   Glibc and nothing else.  If `allLocales' is true, all supported
   locales are included; otherwise, just the locales listed in
   `locales'.  See localedata/SUPPORTED in the Glibc source tree for
   the list of all supported locales:
   http://sourceware.org/cgi-bin/cvsweb.cgi/libc/localedata/SUPPORTED?cvsroot=glibc
*/

{ stdenv, fetchurl, allLocales ? true, locales ? ["en_US.UTF-8/UTF-8"] }:

let build = import ./common.nix;
in
  build null {
    name = "glibc-locales";

    inherit fetchurl stdenv;
    installLocales = true;

    builder = ./locales-builder.sh;

    # Awful hack: `localedef' doesn't allow the path to `locale-archive'
    # to be overriden, but you *can* specify a prefix, i.e. it will use
    # <prefix>/<path-to-glibc>/lib/locale/locale-archive.  So we use
    # $TMPDIR as a prefix, meaning that the locale-archive is placed in
    # $TMPDIR/nix/store/...-glibc-.../lib/locale/locale-archive.
    buildPhase =
      ''
        mkdir -p $TMPDIR/"$(dirname $(readlink -f $(type -p localedef)))/../lib/locale"

        # Hack to allow building of the locales (needed since glibc-2.12)
        sed -i -e "s,^LOCALEDEF=.*,LOCALEDEF=localedef --prefix=$TMPDIR," -e \
            /library-path/d ../glibc-2*/localedata/Makefile
        ${if allLocales then "" else
            "echo SUPPORTED-LOCALES=\"${toString locales}\" > ../glibc-2*/localedata/SUPPORTED"}

        make localedata/install-locales \
            localedir=$out/lib/locale \
      '';

    installPhase =
      ''
        mkdir -p "$out/lib/locale"
        cp -v "$TMPDIR/nix/store/"*"/lib/locale/locale-archive" "$out/lib/locale"
      '';

    meta.description = "Locale information for the GNU C Library";
  }
