{ stdenv
, lib
, fetchFromGitHub
, buildGoPackage
, pkg-config
, deepin-gettext-tools
, go-dbus-factory
, go-gir-generator
, go-lib
, gtk3
, glib
, libxcrypt
, gettext
, iniparser
, cracklib
, linux-pam
}:

buildGoPackage rec {
  pname = "deepin-pw-check";
  version = "5.1.18";

  goPackagePath = "github.com/linuxdeepin/deepin-pw-check";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-v1Z4ArkrejjOCO1vD+BhfEl9pTfuvKgLM6Ont0IUCQk=";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [
    pkg-config
    gettext
    deepin-gettext-tools
  ];

  buildInputs = [
    go-dbus-factory
    go-gir-generator
    go-lib
    glib
    libxcrypt
    gtk3
    iniparser
    cracklib
    linux-pam
  ];

  postPatch = ''
    sed -i 's|iniparser/||' */*.c
    substituteInPlace misc/pkgconfig/libdeepin_pw_check.pc \
      --replace "/usr" "$out"
    substituteInPlace misc/system-services/com.deepin.daemon.PasswdConf.service \
      --replace "/usr/lib/deepin-pw-check/deepin-pw-check" "$out/lib/deepin-pw-check/deepin-pw-check"
  '';

  buildPhase = ''
    runHook preBuild
    GOPATH="$GOPATH:${go-dbus-factory}/share/gocode"
    GOPATH="$GOPATH:${go-gir-generator}/share/gocode"
    GOPATH="$GOPATH:${go-lib}/share/gocode"
    make -C go/src/${goPackagePath}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install PREFIX="$out" PKG_FILE_DIR=$out/lib/pkg-config PAM_MODULE_DIR=$out/etc/pam.d -C go/src/${goPackagePath}
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
