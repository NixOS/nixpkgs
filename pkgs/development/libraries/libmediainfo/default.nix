{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libzen, zlib }:

stdenv.mkDerivation rec {
  version = "22.12";
  pname = "libmediainfo";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libmediainfo/${version}/libmediainfo_${version}.tar.xz";
    sha256 = "sha256-D8bTLwbWzl4UQHTS5X4NuN+k4451LTEjraJ8yviWNLw=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ zlib ];
  propagatedBuildInputs = [ libzen ];

  sourceRoot = "MediaInfoLib/Project/GNU/Library";

  postPatch = lib.optionalString (stdenv.cc.targetPrefix != "") ''
    substituteInPlace configure.ac \
      --replace "pkg-config " "${stdenv.cc.targetPrefix}pkg-config "
  '';

  configureFlags = [ "--enable-shared" ];

  enableParallelBuilding = true;

  postInstall = ''
    install -vD -m 644 libmediainfo.pc "$out/lib/pkgconfig/libmediainfo.pc"
  '';

  meta = with lib; {
    description = "Shared library for mediainfo";
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
