{
  lib,
  stdenvNoCC,
  makeWrapper,
  netcat,
  curl,
  unixtools,
  coreutils,
  mktemp,
  findutils,
  gnugrep,
  fetchFromGitHub,
  gawk,
  gnused,
}:

stdenvNoCC.mkDerivation rec {
  pname = "tinystatus";
  version = "unstable-2021-07-09";

  src = fetchFromGitHub {
    owner = "bderenzo";
    repo = "tinystatus";
    rev = "fc128adf240261ac99ea3e3be8d65a92eda52a73";
    sha256 = "sha256-FvQwibm6F10l9/U3RnNTGu+C2JjHOwbv62VxXAfI7/s=";
  };

  nativeBuildInputs = [ makeWrapper ];

  runtimeInputs = [
    curl
    netcat
    unixtools.ping
    coreutils
    mktemp
    findutils
    gnugrep
    gawk
    gnused
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 tinystatus $out/bin/tinystatus
    wrapProgram $out/bin/tinystatus \
      --set PATH "${lib.makeBinPath runtimeInputs}"
    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preCheck

    cat <<EOF >test.csv
    ping, 0, testing, this.should.fail.example.com
    EOF

    $out/bin/tinystatus test.csv | grep Disrupted

    runHook postCheck
  '';

  meta = with lib; {
    description = "Static HTML status page generator written in pure shell";
    mainProgram = "tinystatus";
    homepage = "https://github.com/bderenzo/tinystatus";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
