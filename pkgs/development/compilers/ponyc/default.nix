{stdenv, glibc, fetchFromGitHub, llvm, makeWrapper, openssl, pcre2, coreutils }:

stdenv.mkDerivation {
  name = "ponyc-2016-07-26";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "ponyc";
    rev = "4eec8a9b0d9936b2a0249bd17fd7a2caac6aaa9c";
    sha256 = "184x2jivp7826i60rf0dpx0a9dg5rsj56dv0cll28as4nyqfmna2";
  };

  buildInputs = [ llvm makeWrapper ];

  # Disable problematic networking tests
  patches = [ ./disable-tests.patch ];

  preBuild = ''
    # Fix tests
    substituteInPlace packages/process/_test.pony \
        --replace "/bin/cat" "${coreutils}/bin/cat"

    export LLVM_CONFIG=${llvm}/bin/llvm-config
  '';

  makeFlags = [ "config=release" ];

  enableParallelBuilding = true;

  doCheck = true;

  checkTarget = "test";

  preCheck = ''
    export LIBRARY_PATH="$out/lib:${stdenv.lib.makeLibraryPath [ openssl pcre2 ]}"
  '';

  installPhase = ''
    make config=release prefix=$out install
    mv $out/bin/ponyc $out/bin/ponyc.wrapped
    makeWrapper $out/bin/ponyc.wrapped $out/bin/ponyc \
      --prefix LIBRARY_PATH : "$out/lib" \
      --prefix LIBRARY_PATH : "${openssl.out}/lib" \
      --prefix LIBRARY_PATH : "${pcre2}/lib"
  '';

  meta = {
    description = "Pony is an Object-oriented, actor-model, capabilities-secure, high performance programming language";
    homepage = http://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.doublec ];
    platforms = stdenv.lib.platforms.linux;
  };
}
