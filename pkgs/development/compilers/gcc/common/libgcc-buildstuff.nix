{ lib
, stdenv
}:

# Trick to build a gcc that is capable of emitting shared libraries *without* having the
# targetPlatform libc available beforehand.  Taken from:
#   https://web.archive.org/web/20170222224855/http://frank.harvard.edu/~coldwell/toolchain/
#   https://web.archive.org/web/20170224235700/http://frank.harvard.edu/~coldwell/toolchain/t-linux.diff
let
  # crt{i,n}.o are the first and last (respectively) object file
  # linked when producing an executable.  Traditionally these
  # files are delivered as part of the C library, but on GNU
  # systems they are in fact built by GCC.  Since libgcc needs to
  # build before glibc, we can't wait for them to be copied by
  # glibc.  At this early pre-glibc stage these files sometimes
  # have different names.
  crtstuff-ofiles =
    if stdenv.targetPlatform.isPower
    then "ecrti.o ecrtn.o ncrti.o ncrtn.o"
    else "crti.o crtn.o";

  # Normally, `SHLIB_LC` is set to `-lc`, which means that
  # `libgcc_s.so` cannot be built until `libc.so` is available.
  # The assignment below clobbers this variable, removing the
  # `-lc`.
  #
  # On PowerPC we add `-mnewlib`, which means "libc has not been
  # built yet".  This causes libgcc's Makefile to use the
  # gcc-built `{e,n}crt{n,i}.o` instead of failing to find the
  # versions which have been repackaged in libc as `crt{n,i}.o`
  #
  SHLIB_LC = lib.optionalString stdenv.targetPlatform.isPower "-mnewlib";

in
''
  echo 'libgcc.a: ${crtstuff-ofiles}' >> libgcc/Makefile.in
  echo 'SHLIB_LC=${SHLIB_LC}' >> libgcc/Makefile.in
''

  # Meanwhile, crt{i,n}.S are not present on certain platforms
  # (e.g. LoongArch64), resulting in the following error:
  #
  # No rule to make target '../../../gcc-xx.x.x/libgcc/config/loongarch/crti.S', needed by 'crti.o'.  Stop.
  #
  # For LoongArch64 and S390, a hacky workaround is to simply touch them,
  # as the platform forces .init_array support.
  #
  # https://www.openwall.com/lists/musl/2022/11/09/3
  #
  # 'parsed.cpu.family' won't be correct for every platform.
+ lib.optionalString (stdenv.targetPlatform.isLoongArch64 || stdenv.targetPlatform.isS390 || stdenv.targetPlatform.isAlpha) ''
  touch libgcc/config/${stdenv.targetPlatform.parsed.cpu.family}/crt{i,n}.S
''
