{ stdenv, lib, fetchFromRepoOrCz, perl, texinfo, which }:

stdenv.mkDerivation rec {
  pname = "tcc";
  version = "unstable-2021-10-09";

  src = fetchFromRepoOrCz {
    repo = "tinycc";
    rev = "ca11849ebb88ef4ff87beda46bf5687e22949bd6";
    sha256 = "sha256-xnUDyTYZxbxUCblACyX73boBhU073VRqSy1SWlWsvIw=";
  };

  nativeBuildInputs = [ perl texinfo which ];

  hardeningDisable = [ "fortify" ];

  postPatch = ''
    patchShebangs texi2pod.pl
  '';

  configureFlags = [
    "--cc=$CC"
    "--ar=$AR"
    "--crtprefix=${lib.getLib stdenv.cc.libc}/lib"
    "--sysincludepaths=${lib.getDev stdenv.cc.libc}/include:{B}/include"
    "--libpaths=${lib.getLib stdenv.cc.libc}/lib"
    # build cross compilers
    "--enable-cross"
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    "--config-musl"
  ];

  preConfigure = ''
    echo ${version} > VERSION
    configureFlagsArray+=("--elfinterp=$(< $NIX_CC/nix-support/dynamic-linker)")
  '';

  postFixup = ''
    cat >libtcc.pc <<EOF
    Name: libtcc
    Description: Tiny C compiler backend
    Version: ${version}
    Libs: -L$out/lib -Wl,--rpath $out/lib -ltcc -ldl
    Cflags: -I$out/include
    EOF
    install -Dt $out/lib/pkgconfig libtcc.pc -m 444
  '';

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "Small, fast, and embeddable C compiler and interpreter";
    longDescription = ''
      TinyCC (aka TCC) is a small but hyper fast C compiler.  Unlike
      other C compilers, it is meant to be self-sufficient: you do not
      need an external assembler or linker because TCC does that for
      you.

      TCC compiles so fast that even for big projects Makefiles may not
      be necessary.

      TCC not only supports ANSI C, but also most of the new ISO C99
      standard and many GNU C extensions.

      TCC can also be used to make C scripts, i.e. pieces of C source
      that you run as a Perl or Python script.  Compilation is so fast
      that your script will be as fast as if it was an executable.

      TCC can also automatically generate memory and bound checks while
      allowing all C pointers operations.  TCC can do these checks even
      if non patched libraries are used.

      With libtcc, you can use TCC as a backend for dynamic code
      generation.
    '';
    homepage = "https://repo.or.cz/tinycc.git";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.joachifm ];
  };
}
