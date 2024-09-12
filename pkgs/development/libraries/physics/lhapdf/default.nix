{ lib, stdenv, fetchurl, python, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lhapdf";
  version = "6.5.4";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/lhapdf/LHAPDF-${version}.tar.gz";
    sha256 = "sha256-JEOksyzDsFl8gki9biVwOs6ckaeiU8X2CxtUKO+chp4=";
  };

  # The Apple SDK only exports locale_t from xlocale.h whereas glibc
  # had decided that xlocale.h should be a part of locale.h
  postPatch = lib.optionalString (stdenv.isDarwin && stdenv.cc.isGNU) ''
    substituteInPlace src/GridPDF.cc --replace '#include <locale>' '#include <xlocale.h>'
  '';

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals (python != null && lib.versionAtLeast python.version "3.10") [ python.pkgs.cython ];
  buildInputs = [ python ];

  configureFlags = lib.optionals (python == null) [ "--disable-python" ];

  preBuild = lib.optionalString (python != null && lib.versionAtLeast python.version "3.10") ''
    rm wrappers/python/lhapdf.cpp
  '';

  enableParallelBuilding = true;

  passthru = {
    pdf_sets = import ./pdf_sets.nix { inherit lib stdenv fetchurl; };
  };

  postInstall = ''
    wrapProgram $out/bin/lhapdf --prefix PYTHONPATH : "$(toPythonPath "$out")"
  '';

  meta = with lib; {
    description = "General purpose interpolator, used for evaluating Parton Distribution Functions from discretised data files";
    license     = licenses.gpl2;
    homepage    = "http://lhapdf.hepforge.org";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
