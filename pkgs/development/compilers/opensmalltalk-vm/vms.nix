{
  "linux64ARMv8" = {
    "squeak.cog.spur" = {
      configureFlagsArray = ''(
        CFLAGS="-march=armv8-a -mtune=cortex-a72 -g -O2 -DNDEBUG -DDEBUGVM=0 -DMUSL -D_GNU_SOURCE -DUSEEVDEV -DCOGMTVM=0 -DDUAL_MAPPED_CODE_ZONE=1"
        LIBS="-lrt"
      )'';
      configureFlags = [
        "--with-vmversion=5.0"
        "--with-src=src/spur64.cog"
        "--without-npsqueak"
        "--with-scriptname=spur64"
        "--enable-fast-bitblt"
      ];
    };
    "squeak.stack.spur" = {
      configureFlagsArray = ''(
        CFLAGS="-g -O2 -DNDEBUG -DDEBUGVM=0 -DMUSL -D_GNU_SOURCE -DUSEEVDEV -D__ARM_ARCH_ISA_A64 -DARM64 -D__arm__ -D__arm64__ -D__aarch64__"
        TARGET_ARCH="-march=armv8-a"
      )'';
      configureFlags = [
        "--with-vmversion=5.0"
        "--with-src=src/spur64.stack"
        "--disable-cogit"
        "--without-npsqueak"
        "--with-scriptname=spur64"
      ];
    };
  };
}
