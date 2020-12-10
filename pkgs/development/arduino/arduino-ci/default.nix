{ stdenv, fetchFromGitHub,  makeWrapper, arduino-cli, ruby, python3, patchelf }:

let

  runtimePath = stdenv.lib.makeBinPath [
    arduino-cli
    (python3.withPackages (ps: [ ps.pyserial ])) # required by esp32 core
    patchelf # required by esp32 core
  ];

in
stdenv.mkDerivation rec {
  pname = "arduino-ci";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner  = "pololu";
    repo   = "arduino-ci";
    rev    = "v${version}";
    sha256 = "sha256-uLCLupzJ446WcxXZtzJk1wnae+k1NTSy0cGHLqW7MZU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install $src/ci.rb $out/bin/arduino-ci

    runHook postInstall
  '';

  fixupPhase = ''
    substituteInPlace $out/bin/arduino-ci --replace "/usr/bin/env nix-shell" "${ruby}/bin/ruby"
    wrapProgram $out/bin/arduino-ci --prefix PATH ":" "${runtimePath}"
  '';

  meta = with stdenv.lib; {
    description = "CI for Arduino Libraries";
    homepage = src.meta.homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
