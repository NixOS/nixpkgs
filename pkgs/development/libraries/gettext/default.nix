{ stdenv, lib, fetchurl, libiconv, xz, bison, automake115x, autoconf }:

let allowBisonDependency = !stdenv.isDarwin; in
stdenv.mkDerivation rec {
  pname = "gettext";
  version = "0.19.8.1";

  src = fetchurl {
    url = "mirror://gnu/gettext/${pname}-${version}.tar.gz";
    sha256 = "0hsw28f9q9xaggjlsdp2qmbp2rbd1mp0njzan2ld9kiqwkq2m57z";
  };
  patches = [
    ./absolute-paths.diff
    (fetchurl {
      name = "CVE-2018-18751.patch";
      url = "https://git.savannah.gnu.org/gitweb/?p=gettext.git;a=patch;h=dce3a16e5e9368245735e29bf498dcd5e3e474a4";
      sha256 = "1lpjwwcjr1sb879faj0xyzw02kma0ivab6xwn3qciy13qy6fq5xn";
    })
  ] ++ lib.optionals (!allowBisonDependency) [
    # Only necessary for CVE-2018-18751.patch:
    ./CVE-2018-18751-bison.patch
  ];

  outputs = [ "out" "man" "doc" "info" ];

  hardeningDisable = [ "format" ];

  LDFLAGS = if stdenv.isSunOS then "-lm -lmd -lmp -luutil -lnvpair -lnsl -lidmap -lavl -lsec" else "";

  configureFlags = [
     "--disable-csharp" "--with-xz"
     # avoid retaining reference to CF during stdenv bootstrap
  ] ++ lib.optionals stdenv.isDarwin [
    "gt_cv_func_CFPreferencesCopyAppValue=no"
    "gt_cv_func_CFLocaleCopyCurrent=no"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # On cross building, gettext supposes that the wchar.h from libc
    # does not fulfill gettext needs, so it tries to work with its
    # own wchar.h file, which does not cope well with the system's
    # wchar.h and stddef.h (gcc-4.3 - glibc-2.9)
    "gl_cv_func_wcwidth_works=yes"
  ];

  postPatch = ''
   substituteAllInPlace gettext-runtime/src/gettext.sh.in
   substituteInPlace gettext-tools/projects/KDE/trigger --replace "/bin/pwd" pwd
   substituteInPlace gettext-tools/projects/GNOME/trigger --replace "/bin/pwd" pwd
   substituteInPlace gettext-tools/src/project-id --replace "/bin/pwd" pwd
  '' + lib.optionalString stdenv.hostPlatform.isCygwin ''
    sed -i -e "s/\(cldr_plurals_LDADD = \)/\\1..\/gnulib-lib\/libxml_rpl.la /" gettext-tools/src/Makefile.in
    sed -i -e "s/\(libgettextsrc_la_LDFLAGS = \)/\\1..\/gnulib-lib\/libxml_rpl.la /" gettext-tools/src/Makefile.in
  '';

  nativeBuildInputs = [
    xz
    xz.bin
  ]
  # Only necessary for CVE-2018-18751.patch (unless CVE-2018-18751-bison.patch
  # is also applied):
  ++ lib.optional allowBisonDependency bison
  ++ [
    # Only necessary for CVE-2018-18751.patch:
    automake115x
    autoconf
  ];
  # HACK, see #10874 (and 14664)
  buildInputs = stdenv.lib.optional (!stdenv.isLinux && !stdenv.hostPlatform.isCygwin) libiconv;

  setupHooks = [
    ../../../build-support/setup-hooks/role.bash
    ./gettext-setup-hook.sh
  ];
  gettextNeedsLdflags = stdenv.hostPlatform.libc != "glibc" && !stdenv.hostPlatform.isMusl;

  enableParallelBuilding = true;
  enableParallelChecking = false; # fails sometimes

  meta = with lib; {
    description = "Well integrated set of translation tools and documentation";

    longDescription = ''
      Usually, programs are written and documented in English, and use
      English at execution time for interacting with users.  Using a common
      language is quite handy for communication between developers,
      maintainers and users from all countries.  On the other hand, most
      people are less comfortable with English than with their own native
      language, and would rather be using their mother tongue for day to
      day's work, as far as possible.  Many would simply love seeing their
      computer screen showing a lot less of English, and far more of their
      own language.

      GNU `gettext' is an important step for the GNU Translation Project, as
      it is an asset on which we may build many other steps. This package
      offers to programmers, translators, and even users, a well integrated
      set of tools and documentation. Specifically, the GNU `gettext'
      utilities are a set of tools that provides a framework to help other
      GNU packages produce multi-lingual messages.
    '';

    homepage = https://www.gnu.org/software/gettext/;

    maintainers = with maintainers; [ zimbatm vrthra ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}

// stdenv.lib.optionalAttrs stdenv.isDarwin {
  makeFlags = "CFLAGS=-D_FORTIFY_SOURCE=0";
}
