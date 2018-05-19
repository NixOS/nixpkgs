{ stdenv, lib, fetchurl, makeWrapper, nodejs, openssl, pcre, readline, sqlite, boehmgc, sfml }:

stdenv.mkDerivation rec {
  name = "nim-${version}";
  version = "0.18.0";

  src = fetchurl {
    url = "https://nim-lang.org/download/${name}.tar.xz";
    sha256 = "45c74adb35f08dfa9add1112ae17330e5d902ebb4a36e7046caee8b79e6f3bd0";
  };

  doCheck = true;

  enableParallelBuilding = true;

  NIX_LDFLAGS = [
    "-lcrypto"
    "-lpcre"
    "-lreadline"
    "-lsqlite3"
    "-lgc"
#    "-lsfml-graphics"
#    "-lsfml-window"
#    "-lsfml-system"
  ];

  # 1. nodejs is only needed for tests
  # 2. we could create a separate derivation for the "written in c" version of nim
  #    used for bootstrapping, but koch insists on moving the nim compiler around
  #    as part of building it, so it cannot be read-only

  buildInputs = [
    makeWrapper nodejs
    openssl pcre readline sqlite boehmgc sfml
  ];

  buildPhase = ''
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

  postPatch = ''
    substituteInPlace ./tests/async/tioselectors.nim --replace "/bin/sleep" "sleep"
    substituteInPlace ./tests/osproc/tworkingdir.nim --replace "/usr/bin/" "/run/current-system/sw/bin/"
  '';

  checkPhase = ''
    ./bin/nimble --nimbleDir:./nimbledir --accept --verbose install zip opengl sdl1 jester@#head niminst
    echo "nimblepath=\"./nimbledir/pkgs/\" >> ./config/nim.cfg
    ./koch tests
  '';

  meta = with stdenv.lib; {
    description = "Statically typed, imperative programming language";
    homepage = https://nim-lang.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ehmry peterhoeg ];
    platforms = with platforms; linux ++ darwin; # arbitrary
  };
}
