args:
( args.mkDerivationByConfiguration {
    flagConfig = {
      mandatory = { buildInputs = "gnumake"; };
    /*
Bigloo compiler:
   --native=yes|no [default yes]
   --jvm=yes|no|force [default no]
   --dotnet=yes|no|force [default no]
   --customgc=yes|no [default yes]
   --bee=partial|full [default partial]

API:
   --enable-[calendar|fthread|mail|multimedia|pkgcomp|pkglib|pthread|sqlite|srfi1|ssl|web]
   --disable-[calendar|fthread|mail|multimedia|pkgcomp|pkglib|pthread|sqlite|srfi1|ssl|web]

Path:
   --prefix=dir (sets bin, lib, zip, man, info and doc dirs)
   --bindir=file
   --libdir=file
   --gcdir=dir (directory for non custom gc library)
   --fildir=file
   --zipdir=file
   --dlldir=file
   --mandir=file
   --infodir=file
   --docdir=file
   --tmpdir=file (Bigloo tmp dir)
   --tmp=file (Installation tmp dir)
   --lispdir=file

Tools and compilers:
   --bigloo=comp [default bigloo]
   --cc=comp [default gcc]
   --ld=comp [default gcc]
   --as=asm
   --cflags=compilation flags
   --lflags=compiler link flags
   --coflags=optimization_flags
   --cpicflags=pic_flags
   --ldlibs=ld_libs
   --ldcomplibs=ld_compiler_libs
   --ldflags=ld_flags
   --emacs=file
   --xemacs=file (deprecated, use "--emacs" option)
   --indent=file
   --icc (configure for icc)

Host configuration:
   --arch=[i586|i686|athlon|athlon-tbird|athlon-mp|athlon-xp|k6-2|k6-3|pentium3|pentium4] (configure for specified hardware)
   --a.out=file
   --a.bat=file
   --dirname=file-or-command
   --force-posixos=operating-system
   --os-win32
   --os-macosx (tune for MacOSX)
   --no-os-macosx (disable MacOSX auto configuration)
   --cygwin-dos-path=[dos path]
   --cygwin-dos-jvm=yes|no [default yes]
   --no-share (disable shared libraries support)
   --no-ldpreload
   --sharedbde=yes|no [default no] (link Bde tools against shared libraries)
   --sharedcompiler=yes|no [default no] (link Bigloo against shared libraries)

JVM configuration:
   --java=file
   --javac=file
   --javaprefix=dir
   --javashell=shell [should be sh or msdos (default sh)]
   --native-default-backend
   --jvm-default-backend

.NET configuration:
   --pnet (configure for GNU pnet)
   --mono (configure for Ximian Mono)
   --dotnetldstyle=style [should be pnet, mono]
   --dotnetcsccstyle=style [should be pnet, mono]
   --dotnetclrstyle=style [should be pnet, mono]
   --dotnetcscc=file
   --dotnetld=file
   --dotnetclr=file
   --dotnetclropt=options
   --dotnetshell=shell [should be sh or msdos (default sh)]
   --dotnetasm=asm [optional]

Misc:
   --finalization=yes|no [default no]
   --benchmark=yes|no [default no] (must use --arch too)
   --stack-check=no

Configuration settings:
   --bigloo.h[=file]
   --bigloo_gc.h[=file]
   --bigloo_config.h[=file]
   --bigloo_config.jvm[=file]
   --Makefile.config=file
   --configure.log=file
   --no-summary
   --bootconfig
   --bootdir=dir
   --configureinfo=yes|no [default no]

   */

    }; 

    extraAttrs = co : rec {
      # Thanks to Manuel Serrano for giving me support
      name = "bigloo3.0d-alpha21Feb08";

      # take care, modifying generated C-Code (altering string and length of string) 
      src = args.fetchurl {
       url = "ftp://ftp-sop.inria.fr/mimosa/fp/Bigloo/${name}.tar.gz";
       sha256 = "1l1qzkia7ah2l8ziig1743h1h41hs1ia8pnip9cjnf87j533yjn9";
      };

      postUnpack = "sed -e 's=/bin/mv/=mv=g' -e 's=/bin/rm=rm=g' -i */configure";

    meta = { 
      description = "scheme -> C / Java compiler (.net experimental)";
      homepage = http://www-sop.inria.fr/mimosa/fp/Bigloo/;
      # you can choose one of the following licenses: 
      license = ["GPL"];
    };
  };
} ) args
