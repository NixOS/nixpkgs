{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "nurbs";
  version = "1.3.13";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0zkyldm63pc3pcal3yvj6af24cvpjvv9qfhf0ihhwcsh4w3yggyv";
  };

  # Has been fixed in more recent commits, but has not been pushed out as a
  # new version yet.
  # The sed changes allow nurbs to compile.
  patchPhase = ''
    sed -i s/feval/octave::feval/g src/*.cc
    sed -i s/is_real_type/isreal/g src/*.cc
    sed -i s/is_cell/iscell/g src/*.cc
  '';

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/nurbs/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Collection of routines for the creation, and manipulation of Non-Uniform Rational B-Splines (NURBS), based on the NURBS toolbox by Mark Spink";
  };
}
