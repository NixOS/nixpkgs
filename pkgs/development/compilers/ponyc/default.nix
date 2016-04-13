{stdenv, glibc, fetchFromGitHub, llvm, makeWrapper, openssl, pcre2 }:

stdenv.mkDerivation {
  name = "ponyc-0.2.1";

  src = fetchFromGitHub {
    owner = "CausalityLtd";
    repo = "ponyc";
    rev = "0.2.1";
    sha256 = "1wmvqrj9v2kjqha9fcs10vfnhdxhc3rf67wpn36ldhs1hq0k25jy";
  };

  buildInputs = [ llvm makeWrapper ];

  makeFlags = [ "config=release" ];
  doCheck = true;
  checkTarget = "test";

  patchPhase = ''
    sed 's|/usr/lib/x86_64-linux-gnu/|${glibc.out}/lib/|g' -i src/libponyc/codegen/genexe.c
    sed 's|/lib/x86_64-linux-gnu/|${stdenv.cc.cc}/lib/|g' -i src/libponyc/codegen/genexe.c
  '';

  preBuild = ''
      export LLVM_CONFIG=${llvm}/bin/llvm-config
    '';

  preCheck = ''
    export LIBRARY_PATH="$out/lib:${openssl.out}/lib:${pcre2}/lib"
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
  };
}
