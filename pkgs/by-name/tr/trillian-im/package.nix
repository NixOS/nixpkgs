{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  atkmm,
  cairo,
  cairomm,
  gtk3,
  gtkmm3,
  libnotify,
  libsecret,
  pangomm,
  xorg,
  libpulseaudio,
  librsvg,
  libzip,
  openssl,
  webkitgtk_4_0,
  libappindicator-gtk3,
}:

stdenv.mkDerivation rec {
  pname = "trillian-im";
  version = "6.3.0.1";

  src = fetchurl {
    url = "https://www.trillian.im/get/linux/6.3/trillian_${version}_amd64.deb";
    sha256 = "42e3466ee236ac2644907059f0961eba3a6ed6b6156afb2c57f54ebe6065ac6f";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    atkmm
    cairo
    cairomm
    gtk3
    gtkmm3
    libnotify
    libsecret
    pangomm
    xorg.libXScrnSaver
    libpulseaudio
    librsvg
    libzip
    openssl
    webkitgtk_4_0
    libappindicator-gtk3
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm -rf $out/usr

    rm $out/bin/trillian
    ln -s "$out/share/trillian/trillian" "$out/bin/trillian"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Modern instant messaging for home and work that prioritizes chat interoperability and security";
    homepage = "https://www.trillian.im/";
    license = licenses.unfree;
    maintainers = with maintainers; [ majiir ];
    platforms = [ "x86_64-linux" ];
  };
}
