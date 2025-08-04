{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoreconfHook,
  makeWrapper,
  perlPackages,
  ocamlPackages,
  libxml2,
  libintl,
}:

stdenv.mkDerivation rec {
  pname = "hivex";
  version = "1.3.24";

  src = fetchurl {
    url = "https://libguestfs.org/download/hivex/${pname}-${version}.tar.gz";
    hash = "sha256-pS+kXOzJp4rbLShgXWgmHk8f1FFKd4pUcwE9LMyKGTw=";
  };

  patches = [ ./hivex-syms.patch ];

  postPatch = ''
    substituteInPlace ocaml/Makefile.am \
        --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib'
  '';

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    perlPackages.perl
    pkg-config
  ]
  ++ (with ocamlPackages; [
    ocaml
    findlib
  ]);
  buildInputs = [
    libxml2
  ]
  ++ (with perlPackages; [
    perl
    IOStringy
  ])
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libintl ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/hivexregedit \
        --set PERL5LIB "$out/${perlPackages.perl.libPrefix}" \
        --prefix "PATH" : "$out/bin"

    wrapProgram $out/bin/hivexml \
        --prefix "PATH" : "$out/bin"
  '';

  meta = {
    description = "Windows registry hive extraction library";
    license = lib.licenses.lgpl2Only;
    homepage = "https://github.com/libguestfs/hivex";
    maintainers = with lib.maintainers; [ offline ];
    platforms = lib.platforms.unix;
  };
}
