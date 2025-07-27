{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
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
  version = "0-unstable-2021-07-09";

  src = fetchFromGitHub {
    owner = "bderenzo";
    repo = "tinystatus";
    rev = "fc128adf240261ac99ea3e3be8d65a92eda52a73";
    hash = "sha256-FvQwibm6F10l9/U3RnNTGu+C2JjHOwbv62VxXAfI7/s=";
  };

  nativeBuildInputs = [ makeWrapper ];

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
