{ stdenv
, fetchurl
, python
}:

stdenv.mkDerivation rec {
  pname = "elliptic_curves";
  version = "0.8";

  src = fetchurl {
    url = "mirror://sageupstream/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0pzaym44x88dn8rydiwqgm73yghzlgf7gqvd7qqsrsdl2vyp091w";
  };


  # Script that creates the sqlite database from the allcurves textfile
  spkg-install = fetchurl {
    url = "https://git.sagemath.org/sage.git/plain/build/pkgs/${pname}/spkg-install.py?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
    sha256 = "116g684i6mvs11fvb6fzfsr4fn903axn31vigdyb8bgpf8l4hvc5";
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

    ${python.interpreter} ${spkg-install}
  '';

  meta = with stdenv.lib; {
    description = "Databases of elliptic curves";
    longDescription = ''
      Includes two databases:

       * A small subset of the data in John Cremona's database of elliptic curves up
         to conductor 10000. See http://www.warwick.ac.uk/~masgaj/ftp/data/ or
         http://sage.math.washington.edu/cremona/INDEX.html
       * William Stein's database of interesting curves
    '';
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = teams.sage.members;
  };
}
