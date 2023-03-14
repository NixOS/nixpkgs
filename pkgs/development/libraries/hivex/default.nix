{ lib, stdenv, fetchurl, pkg-config, autoreconfHook, makeWrapper, perlPackages
, ocamlPackages, libxml2, libintl
}:

stdenv.mkDerivation rec {
  pname = "hivex";
  version = "1.3.21";

  src = fetchurl {
    url = "https://libguestfs.org/download/hivex/${pname}-${version}.tar.gz";
    sha256 = "sha256-ms4+9KL/LKUKmb4Gi2D7H9vJ6rivU+NF6XznW6S2O1Y=";
  };

  patches = [ ./hivex-syms.patch ];

  postPatch = ''
    substituteInPlace ocaml/Makefile.am \
        --replace '$(DESTDIR)$(OCAMLLIB)' '$(out)/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib'
  '';

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook makeWrapper perlPackages.perl pkg-config ]
  ++ (with ocamlPackages; [ ocaml findlib ]);
  buildInputs = [
    libxml2
  ]
  ++ (with perlPackages; [ perl IOStringy ])
  ++ lib.optionals stdenv.isDarwin [ libintl ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/hivexregedit \
        --set PERL5LIB "$out/${perlPackages.perl.libPrefix}" \
        --prefix "PATH" : "$out/bin"

    wrapProgram $out/bin/hivexml \
        --prefix "PATH" : "$out/bin"
  '';

  meta = with lib; {
    description = "Windows registry hive extraction library";
    license = licenses.lgpl2Only;
    homepage = "https://github.com/libguestfs/hivex";
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
