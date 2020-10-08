{ stdenv, fetchurl, python2, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lhapdf";
  version = "6.3.0";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/lhapdf/LHAPDF-${version}.tar.gz";
    sha256 = "0pcvigpjqzfng06n98bshhhpimiqfg416ak8lz8jdgp6nxr8fkgd";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python2 ];

  enableParallelBuilding = true;

  passthru = {
    pdf_sets = import ./pdf_sets.nix { inherit stdenv fetchurl; };
  };

  postInstall = ''
    wrapProgram $out/bin/lhapdf --prefix PYTHONPATH : "$(toPythonPath "$out")"
  '';

  meta = {
    description = "A general purpose interpolator, used for evaluating Parton Distribution Functions from discretised data files";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = "http://lhapdf.hepforge.org";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
