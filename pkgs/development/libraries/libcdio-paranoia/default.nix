{ lib, stdenv, fetchFromGitHub, autoreconfHook, libcdio, pkg-config,
  libiconv, IOKit, DiskArbitration}:

stdenv.mkDerivation {
  name = "libcdio-paranoia-0.94+2";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "libcdio-paranoia";
    rev = "release-10.2+0.94+2";
    sha256 = "1wjgmmaca4baw7k5c3vdap9hnjc49ciagi5kvpvync3aqfmdvkha";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libcdio ] ++
    lib.optionals stdenv.isDarwin [ libiconv IOKit DiskArbitration ];

  propagatedBuildInputs = lib.optional stdenv.isDarwin DiskArbitration;

  configureFlags = lib.optionals stdenv.isDarwin [
    "--disable-ld-version-script"
  ];

  meta = with lib; {
    description = "CD paranoia on top of libcdio";
    longDescription = ''
      This is a port of xiph.org's cdda paranoia to use libcdio for CDROM
      access. By doing this, cdparanoia runs on platforms other than GNU/Linux.
    '';
    license = licenses.gpl3;
    homepage = "https://github.com/rocky/libcdio-paranoia";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ ];
  };
}
