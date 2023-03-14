{ lib, stdenv, fetchurl, fetchpatch, python, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lhapdf";
  version = "6.5.3";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/lhapdf/LHAPDF-${version}.tar.gz";
    sha256 = "sha256-V0Nc1pXilwZdU+ab0pCQdlyTSTa2qXX/jFWXZvIjA1k=";
  };

  patches = [
    # avoid silent compilation failures
    (fetchpatch {
      name = "lhapdf-propagate_returncode.patch";
      url = "https://gitlab.com/hepcedar/lhapdf/-/commit/2806ac795c7e4a69281d9c2a6a8bba5423f37e74.diff";
      hash = "sha256-j8txlt0n5gpUy9zeuWKx+KRXL3HMMaGcwOxr908966k=";
    })

    # workaround "ld: -stack_size option can only be used when linking a main executable" on darwin
    (fetchpatch {
      name = "lhapdf-Wl_stack_size.patch";
      url = "https://gitlab.com/hepcedar/lhapdf/-/commit/463764d6613837b6ab57ecaf13bc61be2349e5e4.diff";
      hash = "sha256-AbDs7gtU5HsJG5n/solMzu2bjX1juxfUIqIt5KmNffU=";
    })
  ];

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
    description = "A general purpose interpolator, used for evaluating Parton Distribution Functions from discretised data files";
    license     = licenses.gpl2;
    homepage    = "http://lhapdf.hepforge.org";
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
