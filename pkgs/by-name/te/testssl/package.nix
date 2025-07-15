{
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  lib,
  dnsutils,
  coreutils,
  openssl,
  nettools,
  util-linux,
  procps,
}:

stdenv.mkDerivation rec {
  pname = "testssl.sh";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "drwetter";
    repo = "testssl.sh";
    rev = "v${version}";
    sha256 = "sha256-jVrEgTgAvu/N0Ijdl4Lya05Q/af7jGTlJBNiYt1X3tI=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    coreutils # for printf
    dnsutils # for dig
    nettools # for hostname
    openssl # for openssl
    procps # for ps
    util-linux # for hexdump
  ];

  postPatch = ''
    substituteInPlace testssl.sh                                               \
      --replace TESTSSL_INSTALL_DIR:-\"\"   TESTSSL_INSTALL_DIR:-\"$out\"      \
      --replace PROG_NAME=\"\$\(basename\ \"\$0\"\)\" PROG_NAME=\"testssl.sh\"
  '';

  installPhase = ''
    install -D testssl.sh $out/bin/testssl.sh
    cp -r etc $out

    wrapProgram $out/bin/testssl.sh --prefix PATH ':' ${lib.makeBinPath buildInputs}
  '';

  meta = with lib; {
    description = "CLI tool to check a server's TLS/SSL capabilities";
    longDescription = ''
      CLI tool which checks a server's service on any port for the support of
      TLS/SSL ciphers, protocols as well as recent cryptographic flaws and more.
    '';
    homepage = "https://testssl.sh/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ etu ];
    mainProgram = "testssl.sh";
  };
}
