{ lib, stdenv, fetchurl, pkg-config, autoreconfHook, makeWrapper
, perlPackages, libxml2, libiconv }:

stdenv.mkDerivation rec {
  pname = "hivex";
  version = "1.3.21";

  src = fetchurl {
    url = "https://libguestfs.org/download/hivex/${pname}-${version}.tar.gz";
    sha256 = "sha256-ms4+9KL/LKUKmb4Gi2D7H9vJ6rivU+NF6XznW6S2O1Y=";
  };

  patches = [ ./hivex-syms.patch ];

  nativeBuildInputs = [ autoreconfHook makeWrapper pkg-config ];
  buildInputs = [
    libxml2
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
    broken = stdenv.isDarwin;
    description = "Windows registry hive extraction library";
    license = licenses.lgpl2;
    homepage = "https://github.com/libguestfs/hivex";
    maintainers = with maintainers; [offline];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
