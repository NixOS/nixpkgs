{ stdenv, fetchurl, python2, makeWrapper }:

stdenv.mkDerivation rec {
  name = "lhapdf-${version}";
  version = "6.2.1";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/lhapdf/LHAPDF-${version}.tar.gz";
    sha256 = "0bi02xcmq5as0wf0jn6i3hx0qy0hj61m02sbrbzd1gwjhpccwmvd";
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
    homepage    = http://lhapdf.hepforge.org;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
