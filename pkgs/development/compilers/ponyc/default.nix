{ stdenv, fetchFromGitHub, llvm, makeWrapper, pcre2, coreutils, which, libressl, libxml2,
  cc ? stdenv.cc, lto ? !stdenv.isDarwin }:

stdenv.mkDerivation ( rec {
  pname = "ponyc";
  version = "0.33.2";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = version;
    sha256 = "0jcdr1r3g8sm3q9fcc87d6x98fg581n6hb90hz7r08mzn4bwvysw";
  };

  buildInputs = [ llvm makeWrapper which libxml2 ];
  propagatedBuildInputs = [ cc ];

  # Disable problematic networking tests
  patches = [ ./disable-tests.patch ];

  preBuild = ''
    # Fix tests
    substituteInPlace packages/process/_test.pony \
        --replace '"/bin/' '"${coreutils}/bin/'
    substituteInPlace packages/process/_test.pony \
        --replace '=/bin' "${coreutils}/bin"

    # Disabling the stdlib tests
    substituteInPlace Makefile-ponyc \
        --replace 'test-ci: all check-version test-core test-stdlib-debug test-stdlib' 'test-ci: all check-version test-core'

    # Remove impure system refs
    substituteInPlace src/libponyc/pkg/package.c \
        --replace "/usr/local/lib" "" \
        --replace "/opt/local/lib" ""

    for file in `grep -irl '/usr/local/opt/libressl/lib' ./*`; do
      substituteInPlace $file  --replace '/usr/local/opt/libressl/lib' "${stdenv.lib.getLib libressl}/lib"
    done

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

  NIX_CFLAGS_COMPILE = [ "-Wno-error=redundant-move" ];

  preCheck = ''
    export PONYPATH="$out/lib:${stdenv.lib.makeLibraryPath [ pcre2 libressl ]}"
  '';

  installPhase = ''
    make config=release prefix=$out ''
    + stdenv.lib.optionalString stdenv.isDarwin '' bits=64 ''
    + stdenv.lib.optionalString (stdenv.isDarwin && (!lto)) '' lto=no ''
    + '' install

    wrapProgram $out/bin/ponyc \
      --prefix PATH ":" "${stdenv.cc}/bin" \
      --set-default CC "$CC" \
      --prefix PONYPATH : "${stdenv.lib.makeLibraryPath [ pcre2 libressl (placeholder "out") ]}"
  '';

  # Stripping breaks linking for ponyc
  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Pony is an Object-oriented, actor-model, capabilities-secure, high performance programming language";
    homepage = https://www.ponylang.org;
    license = licenses.bsd2;
    maintainers = with maintainers; [ doublec kamilchm patternspandemic ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
})
