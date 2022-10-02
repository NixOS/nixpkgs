{ lib, stdenv, fetchFromGitHub, unzip, bintools-unwrapped, coreutils, substituteAll }:

stdenv.mkDerivation rec {
  pname = "cosmopolitan";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "jart";
    repo = pname;
    rev = version;
    sha256 = "sha256-qi82iGw0Sj2pgV9O4rr/q7jyd1XG3MpTr69dXdAUH0Q=";
  };

  patches = [
    # make sure tests set PATH correctly
    (substituteAll { src = ./fix-paths.patch; inherit coreutils; })
  ];

  nativeBuildInputs = [ bintools-unwrapped unzip ];

  outputs = [ "out" "dist" ];

  # slashes are significant because upstream uses o/$(MODE)/foo.o
  buildFlags = "o/cosmopolitan.h o//cosmopolitan.a o//libc/crt/crt.o o//ape/ape.o o//ape/ape.lds";
  checkTarget = "o//test";
  enableParallelBuilding = true;

  doCheck = true;
  dontConfigure = true;
  dontFixup = true;

  preCheck = ''
    # some syscall tests fail because we're in a sandbox
    rm test/libc/calls/sched_setscheduler_test.c
    rm test/libc/thread/pthread_create_test.c
    rm test/libc/calls/getgroups_test.c
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{include,lib}
    install o/cosmopolitan.h $out/include
    install o/cosmopolitan.a o/libc/crt/crt.o o/ape/ape.{o,lds} o/ape/ape-no-modify-self.o $out/lib

    cp -RT . "$dist"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://justine.lol/cosmopolitan/";
    description = "Your build-once run-anywhere c library";
    platforms = platforms.x86_64;
    badPlatforms = platforms.darwin;
    license = licenses.isc;
    maintainers = teams.cosmopolitan.members;
  };
}
