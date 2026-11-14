{
  lib,
  stdenv,
  autoreconfHook,
  automake,
  autoconf,
  bison,
  pkg-config,
  libtool,
  cmakeForConfigure ? null,
  glib,
  boehmgc,
  libx11,
  zlib,
  gettext,
  which,
  perl,
  version,
  src,
  patches ? [ ],
  bootstrapCompiler ? null,
  bootstrapRuntime ? null,
  bootstrapLibraries ? null,
  cflags,
  configureFlags ? [ ],
  makeFlags ? [ ],
  extraNativeBuildInputs ? [ ],
  extraBuildInputs ? [ ],
  enableParallelBuilding ? true,
  doCheck ? false,
  patchReflectionFormatStrings ? true,
  extraPostPatch ? "",
  extraPreConfigure ? "",
  extraPostConfigure ? "",
  extraPreBuild ? "",
  extraPostBuild ? "",
  extraPreInstall ? "",
  extraPostInstall ? "",
}:

let
  hasBootstrapCompiler = bootstrapCompiler != null;
  hasBootstrapRuntime = bootstrapRuntime != null && bootstrapRuntime != bootstrapCompiler;
  hasBootstrapLibraries = bootstrapLibraries != null;
  hasCmakeForConfigure = cmakeForConfigure != null;
  hasPerl = perl != null;
in
stdenv.mkDerivation {
  pname = "mono-bootstrap";
  inherit version src patches;

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    autoconf
    automake
    bison
    libtool
    pkg-config
    which
  ]
  ++ lib.optional hasBootstrapCompiler bootstrapCompiler
  ++ lib.optional hasBootstrapRuntime bootstrapRuntime
  ++ lib.optional hasBootstrapLibraries bootstrapLibraries
  ++ lib.optional hasCmakeForConfigure cmakeForConfigure
  ++ lib.optional hasPerl perl
  ++ extraNativeBuildInputs;

  buildInputs = [
    glib
    boehmgc
    libx11
    zlib
    gettext
  ]
  ++ extraBuildInputs;

  inherit configureFlags enableParallelBuilding doCheck;
  # mono's `make install` recursively descends profiles concurrently and
  # races on `mkdir $out/lib/mono/<profile>` (see mcs/tools/tuner in 1.9.1).
  # Keep build parallel; install serial.
  enableParallelInstalling = false;

  inherit makeFlags;

  dontUseCmakeConfigure = true;

  hardeningDisable = [ "format" ];

  env.CFLAGS = cflags;

  postPatch = ''
    rm -f configure
    rm -rf libgc
    find . -type f \( -name '*.dll' -o -name '*.DLL' -o -name '*.exe' -o -name '*.EXE' -o -name '*.so' \) -delete

    if [ -f Makefile.am ]; then
      if grep -q " docs" Makefile.am; then
        substituteInPlace Makefile.am --replace-fail " docs" ""
      fi
      if grep -q ' $(libgc_dir)' Makefile.am; then
        substituteInPlace Makefile.am --replace-fail ' $(libgc_dir)' ""
      fi
      if grep -q " libgc" Makefile.am; then
        substituteInPlace Makefile.am --replace-fail " libgc" ""
      fi
    fi

    for f in configure.in configure.ac; do
      if [ -f "$f" ]; then
        if grep -q "int f = isinf (1);" "$f"; then
          substituteInPlace "$f" --replace-fail "int f = isinf (1);" "int f = isinf (1.0);"
        fi
      fi
    done

    if [ -f mono/io-layer/processes.c ]; then
      if grep -q '#ifdef HAVE_SYS_MKDEV_H' mono/io-layer/processes.c; then
        substituteInPlace mono/io-layer/processes.c \
          --replace-fail "#ifdef HAVE_SYS_MKDEV_H" "#if 1"
      fi
      if grep -q 'sys/mkdev.h' mono/io-layer/processes.c; then
        substituteInPlace mono/io-layer/processes.c \
          --replace-fail "sys/mkdev.h" "sys/sysmacros.h"
      fi
    fi
    if [ -f mono/io-layer/sockets.c ] && grep -q "int ret, true = 1;" mono/io-layer/sockets.c; then
      substituteInPlace mono/io-layer/sockets.c \
        --replace-fail "int ret, true = 1;" "int ret, reuseaddr = 1;" \
        --replace-fail "&true," "&reuseaddr,"
    fi
    if [ -f mono/metadata/threads-types.h ] && grep -q "MonoBoolean thread_local" mono/metadata/threads-types.h; then
      substituteInPlace mono/metadata/threads-types.h \
        --replace-fail "MonoBoolean thread_local" "MonoBoolean is_thread_local"
    fi
    if [ -f mono/metadata/threads.c ] && grep -q "MonoBoolean thread_local" mono/metadata/threads.c; then
      substituteInPlace mono/metadata/threads.c \
        --replace-fail "MonoBoolean thread_local" "MonoBoolean is_thread_local" \
        --replace-fail "if (thread_local)" "if (is_thread_local)"
    fi
    ${lib.optionalString patchReflectionFormatStrings ''
      if [ -f mono/metadata/reflection.c ]; then
        substituteInPlace mono/metadata/reflection.c \
          --replace-fail "g_string_printf (fullName, info->name);" "g_string_printf (fullName, \"%s\", info->name);" \
          --replace-fail "g_print (obj->vtable->klass->name);" "g_print (\"%s\", obj->vtable->klass->name);"
      fi
    ''}
    if [ -f mono/metadata/boehm-gc.c ]; then
      if grep -q GC_set_finalizer_notify_proc mono/metadata/boehm-gc.c; then
        substituteInPlace mono/metadata/boehm-gc.c \
          --replace-fail GC_set_finalizer_notify_proc GC_set_await_finalize_proc
      fi
      if grep -q GC_toggleref_register_callback mono/metadata/boehm-gc.c; then
        substituteInPlace mono/metadata/boehm-gc.c \
          --replace-fail GC_toggleref_register_callback GC_set_toggleref_func
      fi
    fi
    if [ -f mono/utils/mono-compiler.h ]; then
      if grep -q "static __thread gpointer x MONO_TLS_FAST" mono/utils/mono-compiler.h; then
        substituteInPlace mono/utils/mono-compiler.h \
          --replace-fail "static __thread gpointer x MONO_TLS_FAST" "static __thread gpointer x __attribute__((used))"
      fi
      if grep -q "#define MONO_TLS_FAST " mono/utils/mono-compiler.h; then
        substituteInPlace mono/utils/mono-compiler.h \
          --replace-fail "#define MONO_TLS_FAST " "#define MONO_TLS_FAST __attribute__((used)) "
      fi
    fi
    if [ -f mono/metadata/sgen-alloc.c ]; then
      if grep -q "static __thread char \\*\\*tlab_next_addr" mono/metadata/sgen-alloc.c; then
        substituteInPlace mono/metadata/sgen-alloc.c \
          --replace-fail "static __thread char **tlab_next_addr" "static __thread char **tlab_next_addr __attribute__((used))"
      fi
    fi

    if [ -f mcs/class/System/System.Text.RegularExpressions/BaseMachine.cs-2 ]; then
      mv mcs/class/System/System.Text.RegularExpressions/BaseMachine.cs-2 \
        mcs/class/System/System.Text.RegularExpressions/BaseMachine.cs
    fi
    if [ -f mono/metadata/security.c ]; then
      if ! grep -q '#include <mono/metadata/assembly.h>' mono/metadata/security.c; then
        substituteInPlace mono/metadata/security.c \
          --replace-fail "#include <mono/metadata/image.h>" $'#include <mono/metadata/image.h>\n#include <mono/metadata/assembly.h>'
      fi
    fi
    if [ -f mcs/jay/Makefile ]; then
      substituteInPlace mcs/jay/Makefile \
        --replace-fail 'LOCAL_CFLAGS = -DSKEL_DIRECTORY=\""$(prefix)/share/jay"\"' \
                       'LOCAL_CFLAGS = -std=gnu89 -DSKEL_DIRECTORY=\""$(prefix)/share/jay"\"'
    fi

    if [ -d mcs/class/Managed.Windows.Forms ]; then
      patchShebangs mcs/class/Managed.Windows.Forms/build-csproj*
    fi
    ${extraPostPatch}
  '';

  preConfigure = ''
    export CFLAGS="${cflags}"
    export HOME="$TMPDIR"
    export SOURCE_DATE_EPOCH=315532800
    ${lib.optionalString hasBootstrapLibraries ''
      export CSCC_LIB_PATH="${bootstrapLibraries}/lib/cscc/lib"
    ''}
    ${extraPreConfigure}
  '';

  postConfigure = extraPostConfigure;

  preBuild = extraPreBuild;

  postBuild = extraPostBuild;

  preInstall = extraPreInstall;

  postInstall = ''
    # Trim outputs not used by the next bootstrap stage:
    # docs, locale, static archives, monodoc / lldb support.
    # `rm -rf` is a no-op on missing paths; `find` only walks $out.
    rm -rf "$out"/share/man "$out"/share/doc "$out"/share/gtk-doc \
           "$out"/share/info "$out"/share/locale
    rm -rf "$out"/lib/monodoc "$out"/lib/mono-source-libs \
           "$out"/lib/mono/monodoc "$out"/lib/mono/lldb
    find "$out"/lib -name '*.a' -delete
    # `lib/mono/<ver>-api/` are reference assemblies for end users
    # compiling against specific .NET framework versions. The next
    # bootstrap stage builds its own from `external/binary-reference-
    # assemblies`, so the previous stage's copies are dead weight
    # (~10 MB per profile, ~12 profiles, ~110 MB per late stage).
    if [ -d "$out/lib/mono" ]; then
      find "$out/lib/mono" -mindepth 1 -maxdepth 1 -type d -name '*-api' \
        -exec rm -rf {} +
      # Some build-profile dirs (e.g. `lib/mono/4.0/`) are nothing but
      # symlinks into the now-deleted `*-api/`. Drop the broken links.
      find "$out/lib/mono" -type l ! -exec test -e {} \; -delete
      # And drop the now-empty profile-dirs.
      find "$out/lib/mono" -mindepth 1 -maxdepth 1 -type d -empty -delete
    fi
  ''
  + extraPostInstall;

  meta = {
    description = "Mono bootstrap stage ${version}";
    homepage = "https://www.mono-project.com/";
    license = with lib.licenses; [
      mit
      gpl1Plus
      lgpl2Plus
      bsdOriginal
    ];
    platforms = lib.platforms.linux;
  };
}
