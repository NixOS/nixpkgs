{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsettingsd";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "derat";
    repo = "xsettingsd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CIYshZqJICuL8adKHIN4R6nudaqWOCK2UPrGhsKf9pE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libx11 ];

  # we end up with symlinked unit files if we don't move them around ourselves
  postFixup = ''
    rm -r $out/lib/systemd
    mv $out/share/systemd $out/lib
  '';

  meta = {
    description = "Provides settings to X11 applications via the XSETTINGS specification";
    homepage = "https://github.com/derat/xsettingsd";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ romildo ];
    platforms = lib.platforms.linux;
    mainProgram = "xsettingsd";
  };
})
