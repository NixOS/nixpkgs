{ lib, stdenv, fetchurl, makeWrapper
, pkg-config
, cabextract ? null
, cdrkit ? null
, mtools ? null
, fuse3 ? null
, ntfs3g ? null
, syslinux ? null
}:

stdenv.mkDerivation rec {
  version = "1.14.4";
  pname = "wimlib";

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ ntfs3g ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ fuse3 ];

  src = fetchurl {
    url = "https://wimlib.net/downloads/${pname}-${version}.tar.gz";
    hash = "sha256-NjPbK2yLJV64bTvz3zBZeWvR8I5QuMlyjH62ZmLlEwA=";
  };

  enableParallelBuilding = true;

  preBuild = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace programs/mkwinpeimg.in \
      --replace '/usr/lib/syslinux' "${syslinux}/share/syslinux"
  '';

  postInstall = let
    path = lib.makeBinPath  ([ cabextract mtools ntfs3g ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ cdrkit syslinux fuse3 ]);
  in ''
    for prog in $out/bin/*; do
      wrapProgram $prog --prefix PATH : $out/bin:${path}
    done
  '';

  doCheck = (!stdenv.hostPlatform.isDarwin);

  preCheck = ''
    patchShebangs tests
  '';

  meta = with lib; {
    homepage = "https://wimlib.net";
    description = "Library and program to extract, create, and modify WIM files";
    platforms = platforms.unix;
    maintainers = [ ];
    license = with licenses; [ gpl3 lgpl3 mit ];
  };
}
