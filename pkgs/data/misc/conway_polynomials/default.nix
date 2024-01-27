{ lib, stdenv
, fetchurl
, python3
}:

stdenv.mkDerivation rec {
  pname = "conway_polynomials";
  version = "0.5";

  src = fetchurl {
    url = "mirror://sageupstream/conway_polynomials/conway_polynomials-${version}.tar.bz2";
    sha256 = "05zb1ly9x2bbscqv0jgc45g48xx77mfs7qdbqhn4ihmihn57iwnq";
  };

  # Script that creates the "database" (nested python array) and pickles it
  spkg-install = fetchurl {
    url = "https://raw.githubusercontent.com/sagemath/sage/9.2/build/pkgs/conway_polynomials/spkg-install.py";
    sha256 = "1bwnqasnyv793hxg29viing4dnliz29grkhldsirq19d509yk1fs";
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

    ${python3.interpreter} ${spkg-install}
  '';

  meta = with lib; {
    description = "Contains a small database of Conway polynomials";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = teams.sage.members;
  };
}
