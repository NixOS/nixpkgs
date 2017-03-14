{ stdenv, fetchFromGitHub, llvm, makeWrapper, pcre2, coreutils, which, libressl,
  cc ? stdenv.cc, lto ? !stdenv.isDarwin }:

stdenv.mkDerivation ( rec {
  name = "ponyc-${version}";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "ponyc";
    rev = version;
    sha256 = "08wh8rh17bf043glvn7778bwpxyzpm95kgfll645hf2m65n5ncsh";
  };

  buildInputs = [ llvm makeWrapper which ];
  propagatedBuildInputs = [ cc ];

  # Disable problematic networking tests
  patches = [ ./disable-tests.patch ];

  preBuild = ''
    # Fix tests
    substituteInPlace packages/process/_test.pony \
        --replace '"/bin/' '"${coreutils}/bin/'
    substituteInPlace packages/process/_test.pony \
        --replace '=/bin' "${coreutils}/bin"


    # Fix llvm-ar check for darwin
    substituteInPlace Makefile \
        --replace "llvm-ar-3.8" "llvm-ar"

    # Remove impure system refs
    substituteInPlace src/libponyc/pkg/package.c \
        --replace "/usr/local/lib" ""
    substituteInPlace src/libponyc/pkg/package.c \
        --replace "/opt/local/lib" ""

    for file in `grep -irl '/usr/local/opt/libressl/lib' ./*`; do
      substituteInPlace $file  --replace '/usr/local/opt/libressl/lib' "${stdenv.lib.getLib libressl}/lib"
    done

    # Fix ponypath issue
    substituteInPlace Makefile \
        --replace "PONYPATH=." "PONYPATH=.:\$(PONYPATH)"

    export LLVM_CONFIG=${llvm}/bin/llvm-config
  '' + stdenv.lib.optionalString ((!stdenv.isDarwin) && (!cc.isClang) && lto) ''
    export LTO_PLUGIN=`find ${cc.cc}/ -name liblto_plugin.so`
  '' + stdenv.lib.optionalString ((!stdenv.isDarwin) && (cc.isClang) && lto) ''
    export LTO_PLUGIN=`find ${cc.cc}/ -name LLVMgold.so`
  '';

  makeFlags = [ "config=release" ] ++ stdenv.lib.optionals stdenv.isDarwin [ "bits=64" ]
              ++ stdenv.lib.optionals (stdenv.isDarwin && (!lto)) [ "lto=no" ];

  enableParallelBuilding = true;

  doCheck = true;

  checkTarget = "test-ci";

  preCheck = ''
    export PONYPATH="$out/lib:${stdenv.lib.makeLibraryPath [ pcre2 libressl ]}"
  '';

  installPhase = ''
    make config=release prefix=$out ''
    + stdenv.lib.optionalString stdenv.isDarwin '' bits=64 ''
    + stdenv.lib.optionalString (stdenv.isDarwin && (!lto)) '' lto=no ''
    + '' install
    mv $out/bin/ponyc $out/bin/ponyc.wrapped
    makeWrapper $out/bin/ponyc.wrapped $out/bin/ponyc \
      --prefix PONYPATH : "$out/lib" \
      --prefix PONYPATH : "${stdenv.lib.getLib pcre2}/lib" \
      --prefix PONYPATH : "${stdenv.lib.getLib libressl}/lib"
  '';

  # Stripping breaks linking for ponyc
  dontStrip = true;

  meta = {
    description = "Pony is an Object-oriented, actor-model, capabilities-secure, high performance programming language";
    homepage = http://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ doublec kamilchm ];
    platforms = stdenv.lib.platforms.unix;
  };
})
