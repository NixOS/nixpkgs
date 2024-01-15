{ lib, stdenv, fetchFromGitHub, autoreconfHook, libcdio, pkg-config,
  libiconv, IOKit, DiskArbitration}:

stdenv.mkDerivation rec {
  pname = "libcdio-paranoia";
  version = "0.94+2";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "libcdio-paranoia";
    rev = "release-10.2+${version}";
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
    homepage = "https://github.com/rocky/libcdio-paranoia";
    license = licenses.gpl3;
    maintainers = [ ];
    mainProgram = "cd-paranoia";
    platforms = platforms.unix;
  };
}
