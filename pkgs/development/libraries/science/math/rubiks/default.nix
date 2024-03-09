{ lib, stdenv
, fetchurl
, fetchpatch
, coreutils
}:

stdenv.mkDerivation rec {
  pname = "rubiks";
  version = "20070912";

  src = fetchurl {
    url = "mirror://sageupstream/rubiks/rubiks-${version}.tar.bz2";
    sha256 = "0zdmkb0j1kyspdpsszzb2k3279xij79jkx0dxd9f3ix1yyyg3yfq";
  };

  preConfigure = ''
    export INSTALL="${coreutils}/bin/install"
  '';

  # everything is done in `make install`
  buildPhase = "true";

  installFlags = [
    "PREFIX=$(out)"
  ];

  patches = [
    # Fix makefiles which use all the variables in all the wrong ways and
    # hardcode values for some variables.
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/07d6c37d18811e2b377a9689790a7c5e24da16ba/build/pkgs/rubiks/patches/dietz-cu2-Makefile.patch";
      sha256 = "1ry3w1mk9q4jqd91zlaa1bdiiplld4hpfjaldbhlmzlgrrc99qmq";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/07d6c37d18811e2b377a9689790a7c5e24da16ba/build/pkgs/rubiks/patches/dietz-mcube-Makefile.patch";
      sha256 = "0zsbh6k3kqdg82fv0kzghr1x7pafisv943gmssqscp107bhg77bz";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/07d6c37d18811e2b377a9689790a7c5e24da16ba/build/pkgs/rubiks/patches/dietz-solver-Makefile.patch";
      sha256 = "0vhw70ylnmydgjhwx8jjlb2slccj4pfqn6vzirkyz1wp8apsmfhp";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/07d6c37d18811e2b377a9689790a7c5e24da16ba/build/pkgs/rubiks/patches/reid-Makefile.patch";
      sha256 = "1r311sn012xs135s0d21qwsig2kld7rdcq19nm0zbnklviid57df";
    })
  ];

  meta = with lib; {
    homepage = "https://wiki.sagemath.org/spkg/rubiks";
    description = "Several programs for working with Rubik's cubes";
    # The individual websites are no longer available
    longDescription = ''
      There are several programs for working with Rubik's cubes, by three
      different people. Look inside the directories under /src to see
      specific info and licensing. In summary the three contributers are:


      Michael Reid (GPL) http://www.math.ucf.edu/~reid/Rubik/optimal_solver.html
          optimal - uses many pre-computed tables to find an optimal
                    solution to the 3x3x3 Rubik's cube


      Dik T. Winter (MIT License)
          cube    - uses Kociemba's algorithm to iteratively find a short
                    solution to the 3x3x3 Rubik's cube
          size222 - solves a 2x2x2 Rubik's cube


      Eric Dietz (GPL) http://www.wrongway.org/?rubiksource
          cu2   - A fast, non-optimal 2x2x2 solver
          cubex - A fast, non-optimal 3x3x3 solver
          mcube - A fast, non-optimal 4x4x4 solver
    '';
    license = with licenses; [
      gpl2 # Michael Reid's and Eric Dietz software
      mit # Dik T. Winter's software
    ];
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
