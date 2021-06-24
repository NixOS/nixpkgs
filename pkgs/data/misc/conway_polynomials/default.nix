{ lib, stdenv
, fetchurl
, python2
}:

stdenv.mkDerivation rec {
  pname = "conway_polynomials";
  version = "0.5";

  pythonEnv = python2.withPackages (ps: with ps; [ six ]);

  src = fetchurl {
    url = "mirror://sageupstream/conway_polynomials/conway_polynomials-${version}.tar.bz2";
    sha256 = "05zb1ly9x2bbscqv0jgc45g48xx77mfs7qdbqhn4ihmihn57iwnq";
  };

  # Script that creates the "database" (nested python array) and pickles it
  spkg-install = fetchurl {
    url = "https://git.sagemath.org/sage.git/plain/build/pkgs/conway_polynomials/spkg-install.py?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
    sha256 = "0m12nfb37j3bn4bp06ddgnyp2d6z0hg5f83pbbjszxw7vxs33a82";
  };

  installPhase = ''
    # directory layout as spkg-install.py expects
    dir="$PWD"
    cd ..
    ln -s "$dir" "src"

    # environment spkg-install.py expects
    mkdir -p "$out/share"
    export SAGE_SHARE="$out/share"
    export PYTHONPATH=$PWD

    ${pythonEnv.interpreter} ${spkg-install}
  '';

  meta = with lib; {
    description = "Contains a small database of Conway polynomials";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = teams.sage.members;
  };
}
