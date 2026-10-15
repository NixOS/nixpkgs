{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.4.5";
  pname = "theft";

  src = fetchFromGitHub {
    owner = "silentbicycle";
    repo = "theft";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DUp85uINe9roE13k3FZZW0pMef+tDs8vaXcJ6riaVdg=";
  };

  patches = [ ./disable-failing-test.patch ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "ar -rcs" "${stdenv.cc.targetPrefix}ar -rcs"
  '';

  preConfigure = "patchShebangs ./scripts/mk_bits_lut";

  doCheck = true;
  checkTarget = "test";

  installFlags = [ "PREFIX=$(out)" ];

  # fix the libtheft.pc file to use the right installation
  # directory. should be fixed upstream, too
  postInstall = ''
    install -m644 vendor/greatest.h $out/include/

    substituteInPlace $out/lib/pkgconfig/libtheft.pc \
      --replace "/usr/local" "$out"
  '';

  meta = {
    description = "C library for property-based testing";
    homepage = "https://github.com/silentbicycle/theft/";
    platforms = lib.platforms.unix;
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      kquick
      thoughtpolice
    ];
  };
})
