{ stdenv, lib, fetchurl, libiconv }:

let common = import ../gettext/common.nix { inherit fetchurl; };
in stdenv.mkDerivation rec {
  pname = "gettext-runtime";
  inherit (common) version src;

  sourceRoot = "${common.pname}-${common.version}/${pname}/";

  # Sources are within a subdir of the upstream directory. Given
  # that patches are applied from sourceRoot, we cannot just
  # fetch patches upstream in order to backport them. We have
  # to update them to accomodate the effective root.
  patches = [
    ./absolute-paths.diff
  ] ++ lib.optional stdenv.isDarwin [
    ./gettext.git-ec0e6b307456ceab352669ae6bccca9702108753.patch
  ];

  outputs = [ "out" "man" "doc" "info" ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--disable-csharp"
    "--with-xz"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # On cross building, gettext supposes that the wchar.h from libc
    # does not fulfill gettext needs, so it tries to work with its
    # own wchar.h file, which does not cope well with the system's
    # wchar.h and stddef.h (gcc-4.3 - glibc-2.9)
    "gl_cv_func_wcwidth_works=yes"
  ];

  postPatch = ''
    substituteAllInPlace src/gettext.sh.in
  '';

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

    homepage = "https://www.gnu.org/software/gettext/";

    maintainers = with maintainers; [ zimbatm vrthra lsix ];

    # Licensing changes from component to component.
    # see https://git.savannah.gnu.org/gitweb/?p=gettext.git;a=blob;f=gettext-runtime/COPYING;h=9045d4cd3fdc2f192776f6663ff5411ded29f8a1;hb=7ab696c983ab080a21dc06e422366c086d7dd91a
    license = [ licenses.lgpl21Plus licenses.gpl3 ];
    platforms = platforms.all;
  };
}
