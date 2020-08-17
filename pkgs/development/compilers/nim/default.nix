# based on https://github.com/nim-lang/Nim/blob/v0.18.0/.travis.yml

{ stdenv, lib, fetchurl, makeWrapper, openssl, pcre, readline,
  boehmgc, sfml, sqlite }:

stdenv.mkDerivation rec {
  pname = "nim";
  version = "1.2.6";

  src = fetchurl {
    url = "https://nim-lang.org/download/${pname}-${version}.tar.xz";
    sha256 = "0zk5qzxayqjw7kq6p92j4008g9bbyilyymhdc5xq9sln5rqym26z";
  };

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lcrypto -lpcre -lreadline -lgc -lsqlite3";

  # we could create a separate derivation for the "written in c" version of nim
  # used for bootstrapping, but koch insists on moving the nim compiler around
  # as part of building it, so it cannot be read-only

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    openssl pcre readline boehmgc sfml sqlite
  ];

  buildPhase = ''
    runHook preBuild

    # build.sh wants to write to $HOME/.cache
    HOME=$TMPDIR
    sh build.sh
    ./bin/nim c koch
    ./koch boot  -d:release \
                 -d:useGnuReadline \
                 ${lib.optionals (stdenv.isDarwin || stdenv.isLinux) "-d:nativeStacktrace"}
    ./koch tools -d:release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/bin bin/* koch
    ./koch install $out
    mv $out/nim/bin/* $out/bin/ && rmdir $out/nim/bin
    mv $out/nim/*     $out/     && rmdir $out/nim

    # Fortify hardening appends -O2 to gcc flags which is unwanted for unoptimized nim builds.
    wrapProgram $out/bin/nim \
      --run 'NIX_HARDENING_ENABLE=''${NIX_HARDENING_ENABLE/fortify/}' \
      --suffix PATH : ${lib.makeBinPath [ stdenv.cc ]}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Statically typed, imperative programming language";
    homepage = "https://nim-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; linux ++ darwin; # arbitrary
  };
}
