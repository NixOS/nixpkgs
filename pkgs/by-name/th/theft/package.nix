{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  version = "0.4.5";
  pname = "theft";

  src = fetchFromGitHub {
    owner = "silentbicycle";
    repo = "theft";
    rev = "v${version}";
    sha256 = "1n2mkawfl2bpd4pwy3mdzxwlqjjvb5bdrr2x2gldlyqdwbk7qjhd";
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

  meta = with lib; {
    description = "C library for property-based testing";
    homepage = "https://github.com/silentbicycle/theft/";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [
      kquick
      thoughtpolice
    ];
  };
}
