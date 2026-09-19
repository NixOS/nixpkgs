# The `system-cxx-std-lib` package.
#
# This one is not built from source, because upstream has no source for it.
# It is `mk/system-cxx-std-lib-1.0.conf.in` — a hand-written package.conf whose
# body is a `.in` template:
#
#     name: system-cxx-std-lib
#     version: 1.0
#     extra-libraries:      @CXX_STD_LIB_LIBS@
#     library-dirs:         @CXX_STD_LIB_LIB_DIRS@
#     dynamic-library-dirs: @CXX_STD_LIB_DYN_LIB_DIRS@
#
# It exists so that Haskell code needing the C++ standard library can depend on
# it portably; GHC links via the C compiler, which does not pull libstdc++ in on
# its own. See the `description` field of the template, and
# `GHC.Driver.CodeOutput`.
#
# Those three variables are the one part of the settings story that really is a
# *probe* of the C++ toolchain, which is why this cannot live in the
# platform-independent source derivation. nixpkgs knows the answers from
# `stdenv`, so no probing is needed.
{
  lib,
  stdenv,
  runCommand,
  ghcVersion,
  ghcSrc,
}:

let
  # libstdc++ with gcc, libc++ with a clang-based stdenv.
  isLibcxx = stdenv.cc.libcxx != null;
  cxxLib = if isLibcxx then stdenv.cc.libcxx else stdenv.cc.cc.lib or stdenv.cc.cc;
  cxxLibName = if isLibcxx then "c++" else "stdc++";

  libDir = "${lib.getLib cxxLib}/lib";
in

runCommand "system-cxx-std-lib-1.0"
  {
    passthru = {
      inherit cxxLibName libDir;
      # `generic-builder` decides whether a dependency is a Haskell package by
      # looking for this.
      isHaskellLibrary = true;
      pname = "system-cxx-std-lib";
      version = "1.0";
    };
    meta = {
      description = "Placeholder package for the system C++ standard library";
      license = lib.licenses.bsd3;
      platforms = lib.platforms.all;
    };
  }
  (
    # The layout `generic-builder`'s `buildPkgDb` looks for: a `package.conf.d`
    # under the compiler's libdir.
    ''
      d="$out/lib/ghc-${ghcVersion}/package.conf.d"
      mkdir -p "$d"
    ''
    # The template is upstream's, so the field list tracks the release rather
    # than a copy here that drifts. 9.15 already added `extra-libraries-static`,
    # which uses the same variable and so needs nothing from us.
    #
    # `--replace-fail` rather than `--replace`: if upstream renames a variable,
    # failing loudly beats installing a `.conf` with a literal
    # `@CXX_STD_LIB_LIBS@` in it, which would only surface at link time in some
    # unrelated package.
    + ''
      substitute ${ghcSrc}/mk/system-cxx-std-lib-1.0.conf.in \
        "$d/system-cxx-std-lib-1.0.conf" \
        --replace-fail '@CXX_STD_LIB_LIBS@' '${cxxLibName}' \
        --replace-fail '@CXX_STD_LIB_LIB_DIRS@' '${libDir}' \
        --replace-fail '@CXX_STD_LIB_DYN_LIB_DIRS@' '${libDir}'
    ''
  )
