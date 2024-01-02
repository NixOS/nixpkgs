{ lib
, fetchFromGitHub
, buildGoModule
, pkg-config
, deepin-gettext-tools
, gtk3
, glib
, libxcrypt
, gettext
, iniparser
, cracklib
, linux-pam
}:

buildGoModule rec {
  pname = "deepin-pw-check";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-kBrkcB0IWGUV4ZrkFzwdPglRgDcnVvYDFhTXS20pKOk=";
  };

  vendorHash = "sha256-L0vUEkUN70Hrx5roIvTfaZBHbbq7mf3WpQJeFAMU5HY=";

  nativeBuildInputs = [
    pkg-config
    gettext
    deepin-gettext-tools
  ];

  buildInputs = [
    glib
    libxcrypt
    gtk3
    iniparser
    cracklib
    linux-pam
  ];

  postPatch = ''
    sed -i 's|iniparser/||' */*.c
    substituteInPlace misc/{pkgconfig/libdeepin_pw_check.pc,system-services/org.deepin.dde.PasswdConf1.service} \
      --replace "/usr" "$out"
  '';

  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install PREFIX="$out" PKG_FILE_DIR=$out/lib/pkgconfig PAM_MODULE_DIR=$out/etc/pam.d
    # https://github.com/linuxdeepin/deepin-pw-check/blob/d5597482678a489077a506a87f06d2b6c4e7e4ed/debian/rules#L21
    ln -s $out/lib/libdeepin_pw_check.so $out/lib/libdeepin_pw_check.so.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to verify the validity of the password";
    homepage = "https://github.com/linuxdeepin/deepin-pw-check";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
