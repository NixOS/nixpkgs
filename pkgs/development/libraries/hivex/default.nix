{ lib, stdenv, fetchurl, pkg-config, autoreconfHook, makeWrapper
, perlPackages, libxml2, libiconv }:

stdenv.mkDerivation rec {
  pname = "hivex";
  version = "1.3.20";

  src = fetchurl {
    url = "https://libguestfs.org/download/hivex/${pname}-${version}.tar.gz";
    sha256 = "sha256-9SPDe7BkpLq321IkkCw07uT5+rLZuBz2FbMsC4UJ0y0=";
  };

  patches = [ ./hivex-syms.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    autoreconfHook makeWrapper libxml2
  ]
  ++ (with perlPackages; [ perl IOStringy ])
  ++ lib.optionals stdenv.isDarwin [ libiconv ];

  postInstall = ''
    wrapProgram $out/bin/hivexregedit \
        --set PERL5LIB "$out/${perlPackages.perl.libPrefix}" \
        --prefix "PATH" : "$out/bin"

    wrapProgram $out/bin/hivexml \
        --prefix "PATH" : "$out/bin"
  '';

  meta = with lib; {
    description = "Windows registry hive extraction library";
    license = licenses.lgpl2;
    homepage = "https://github.com/libguestfs/hivex";
    maintainers = with maintainers; [offline];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
