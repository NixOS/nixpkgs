{ stdenv, lib, fetchurl, makeWrapper, nodejs, openssl, pcre, readline, sqlite }:

stdenv.mkDerivation rec {
  name = "nim-${version}";
  version = "0.17.0";

  src = fetchurl {
    url = "http://nim-lang.org/download/${name}.tar.xz";
    sha256 = "16vsmk4rqnkg9lc9h9jk62ps0x778cdqg6qrs3k6fv2g73cqvq9n";
  };

  doCheck = true;

  enableParallelBuilding = true;

  NIX_LDFLAGS = [
    "-lcrypto"
    "-lpcre"
    "-lreadline"
    "-lsqlite3"
  ];

  # 1. nodejs is only needed for tests
  # 2. we could create a separate derivation for the "written in c" version of nim
  #    used for bootstrapping, but koch insists on moving the nim compiler around
  #    as part of building it, so it cannot be read-only

  buildInputs  = [
    makeWrapper nodejs
    openssl pcre readline sqlite
  ];

  buildPhase   = ''
    sh build.sh
    ./bin/nim c koch
    ./koch boot  -d:release \
                 -d:useGnuReadline \
                 ${lib.optionals (stdenv.isDarwin || stdenv.isLinux) "-d:nativeStacktrace"}
    ./koch tools -d:release
  '';

  installPhase = ''
    install -Dt $out/bin bin/* koch
    ./koch install $out
    mv $out/nim/bin/* $out/bin/ && rmdir $out/nim/bin
    mv $out/nim/*     $out/     && rmdir $out/nim
    wrapProgram $out/bin/nim \
      --suffix PATH : ${lib.makeBinPath [ stdenv.cc ]}
  '';

  checkPhase = "./koch tests";

  meta = with stdenv.lib; {
    description = "Statically typed, imperative programming language";
    homepage = http://nim-lang.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry peterhoeg ];
    platforms = with platforms; linux ++ darwin; # arbitrary
  };
}
