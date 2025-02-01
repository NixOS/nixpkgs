{
  lib,
  stdenv,
  fetchurl,
  boehmgc,
  glib,
  help2man,
  libgee,
  ncurses,
  perl,
  pkg-config,
  vala,
}:

stdenv.mkDerivation rec {
  pname = "zile";
  version = "2.6.2";

  src = fetchurl {
    url = "mirror://gnu/zile/${pname}-${version}.tar.gz";
    hash = "sha256-d+t9r/PJi9yI2qGsBA3MynK4HcMvwxZuB53Xpj5Cx0E=";
  };

  buildInputs = [
    boehmgc
    glib
    libgee
    ncurses
  ];
  nativeBuildInputs =
    [
      perl
      pkg-config
      vala
    ]
    # `help2man' wants to run Zile, which won't work when the
    # newly-produced binary can't be run at build-time.
    ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) help2man;

  # Tests can't be run because most of them rely on the ability to
  # fiddle with the terminal.
  doCheck = false;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=incompatible-function-pointer-types";

  # XXX: Work around cross-compilation-unfriendly `gl_FUNC_FSTATAT' macro.
  gl_cv_func_fstatat_zero_flag = "yes";

  meta = with lib; {
    homepage = "https://www.gnu.org/software/zile/";
    changelog = "https://git.savannah.gnu.org/cgit/zile.git/plain/NEWS?h=v${version}";
    description = "Zile Implements Lua Editors";
    longDescription = ''
      GNU Zile is a text editor development kit, so that you can (relatively)
      quickly develop your own ideal text editor without reinventing the wheel
      for many of the common algorithms and data-structures needed to do so.

      It comes with an example implementation of a lightweight Emacs clone,
      called Zemacs. Every Emacs user should feel at home with Zemacs. Zemacs is
      aimed at small footprint systems and quick editing sessions (it starts up
      and shuts down instantly).

      More editors implemented over the Zile frameworks are forthcoming as the
      data-structures and interfaces improve: Zz an emacs inspired editor using
      Lua as an extension language; Zee a minimalist non-modal editor; Zi a
      lightweight vi clone; and more...

      Zile is a collection of algorithms and data-structures that currently
      support all basic Emacs-like editing features: it is 8-bit clean (though
      Unicode support is not ready yet), and the number of editing buffers and
      windows is only limited by available memoryand screen space
      respectively. Registers, minibuffer completion and auto fill are
      available.

      Zemacs implements a subset of Emacs with identical function and variable
      names, continuing the spirit of the earlier Zile editor implemented in C.
      GNU Zile, which is a lightweight Emacs clone.  Zile is short for Zile Is
      Lossy Emacs.  Zile has been written to be as similar as possible to Emacs;
      every Emacs user should feel at home.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
    mainProgram = "zile";
  };
}
