{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "systemd-lock-handler";
  version = "2.4.2";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "systemd-lock-handler";
    rev = "v${version}";
    hash = "sha256-sTVAabwWtyvHuDp/+8FKNbfej1x/egoa9z1jLIMJuBg=";
  };

  vendorHash = "sha256-dWzojV3tDA5lLdpAQNC9NaADGyvV7dNOS3x8mfgNNtA=";

  passthru = {
    updateScript = nix-update-script { };
    tests = nixosTests.systemd-lock-handler;
  };

  # The Makefile expects to find the binary in the source root. Make
  # the one built by `buildGoModule` available so that `make install`
  # doesn’t try to build it again.
  postBuild = ''
    cp -a $GOPATH/bin/* .
  '';

  installPhase = ''
    runHook preInstall

    substituteInPlace systemd-lock-handler.service \
      --replace /usr/lib/ $out/lib/

    make install DESTDIR= PREFIX=$out

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~whynothugo/systemd-lock-handler";
    description = "Translates systemd-system lock/sleep signals into systemd-user target activations";
    license = licenses.isc;
    maintainers = with maintainers; [ liff ];
    platforms = platforms.linux;
  };
}
