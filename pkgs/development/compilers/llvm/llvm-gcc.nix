args : with args; 
rec {
  src = fetchurl {
    url = http://llvm.org/releases/2.2/llvm-gcc4.2-2.2.source.tar.gz;
    sha256 = "11vjn8wn76cq63jam7y5ralq1b12r6cdipf22nsnzw90srb49qkp";
  };

  buildInputs = [llvm bison flex perl libtool];
  configureFlags = [ " --enable-languages=c,c++ " ];
  makeFlags = [" -f Makefile "];

  phaseNames = [ "doPatch" "preConfigure" "doConfigure" 
    "doMakeInstall" "postInstall"];

  patches = [ ./no-sys-dirs.patch ];

  preConfigure = FullDepEntry (''

    sed -e 's,^LLVMSRCDIR.*,LLVMSRCDIR := dummy,' \
        -e 's,\$(LLVMSRCDIR)/include,${llvm}/include,g' \
        -e 's,^LLVMOBJDIR.*,LLVMOBJDIR := dummy,' \
        -e 's,\$(LLVMOBJDIR)/include,${llvm}/include,g' \
        -e 's,^LLVMBINPATH.*,LLVMBINPATH = ${llvm}/bin,' \
        -i gcc/Makefile.in 

    cd ..
    mkdir obj install
    cd obj

    export NIX_FIXINC_DUMMY=$NIX_BUILD_TOP/dummy
    mkdir $NIX_FIXINC_DUMMY

    export CPP="gcc -E"

    # Figure out what extra flags to pass to the gcc compilers
    # being generated to make sure that they use our glibc.
    extraCFlags="$(cat $NIX_GCC/nix-support/libc-cflags)"
    extraLDFlags="$(cat $NIX_GCC/nix-support/libc-ldflags) $(cat $NIX_GCC/nix-support/libc-ldflags-before)"

    # Use *real* header files, otherwise a limits.h is generated
    # that does not include Glibc's limits.h (notably missing
    # SSIZE_MAX, which breaks the build).
    export NIX_FIXINC_DUMMY=$(cat $NIX_GCC/nix-support/orig-libc)/include

    extraCFlags="-g0 $extraCFlags"
    extraLDFlags="--strip-debug $extraLDFlags"

    export NIX_EXTRA_CFLAGS=$extraCFlags
    for i in $extraLDFlags; do
        export NIX_EXTRA_LDFLAGS="$NIX_EXTRA_LDFLAGS -Wl,$i"
    done

  '') ["doUnpack" "minInit"];
  configureCommand = "$(ls ../llvm-gcc*.*.source/configure)";

  postInstall = FullDepEntry (''
    mv $out/bin/gcc $out/bin/llvm-gcc
    mv $out/bin/g++ $out/bin/llvm-g++
  '')["doMakeInstall" "minInit"];
  
  name = "llvm-gcc42-2.2";
  meta = {
    description = "LLVM GCC frontend";
  };
}

  
