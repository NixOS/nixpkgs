{
  lib,
  stdenv,
  fetchurl,
  gtk-engine-murrine,
}:

stdenv.mkDerivation rec {
  pname = "juno";
  version = "0.0.1";

  srcs = [
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno.tar.xz";
      sha256 = "1cghsn9qagcf1nlga5cal0aqch6hkjm5wk6ja791zxhdqy3crx1i";
    })
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno-mirage.tar.xz";
      sha256 = "0zh6bc85svmwh8qrhpn8mim0pj322x2x2i9sxnp7p1938p5z5m2b";
    })
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno-ocean.tar.xz";
      sha256 = "0m2wgmcn12dfq5badzlpzjc8792ba9hi32c79vfvqawdn1q3hrdx";
    })
    (fetchurl {
      url = "https://github.com/gvolpe/Juno/releases/download/${version}/Juno-palenight.tar.xz";
      sha256 = "1hn2l0m76x61ixjd253hi7czm65asdjdhqvvlv7idbccc40pvrak";
    })
  ];

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a Juno* $out/share/themes
    rm $out/share/themes/*/{LICENSE,README.md}
    runHook postInstall
  '';

  meta = with lib; {
    description = "GTK themes inspired by epic vscode themes";
    homepage = "https://github.com/EliverLara/Juno";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.gvolpe ];
  };
}
