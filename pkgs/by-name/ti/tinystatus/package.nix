{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  coreutils,
  curl,
  findutils,
  gawk,
  gnugrep,
  gnused,
  mktemp,
  netcat,
  unixtools,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tinystatus";
  version = "0-unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "bderenzo";
    repo = "tinystatus";
    rev = "169ee0bb2efe4531080936d1e2a46e451feebe3e";
    hash = "sha256-nPrABKKIDP1n1rhcojFJJ15kqa5b4s7F/wMAgD/eVBw=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 tinystatus $out/bin/tinystatus
    wrapProgram $out/bin/tinystatus \
      --set PATH "${
        lib.makeBinPath [
          coreutils
          curl
          findutils
          gawk
          gnugrep
          gnused
          mktemp
          netcat
          unixtools.ping
        ]
      }"

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    cat <<EOF >test.csv
    ping, 0, testing, this.should.fail.example.com
    EOF

    $out/bin/tinystatus test.csv | grep Disrupted

    runHook postInstallCheck
  '';

  meta = {
    description = "Static HTML status page generator written in pure shell";
    mainProgram = "tinystatus";
    homepage = "https://github.com/bderenzo/tinystatus";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
})
