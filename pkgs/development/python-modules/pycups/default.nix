{stdenv, fetchurl, python, cups}:

stdenv.mkDerivation {
  name = "pycups-1.9.46";
  src = fetchurl {
    url = http://cyberelk.net/tim/data/pycups/pycups-1.9.46.tar.bz2;
    sha256 = "1zn85gkpdzvkiwbmn466cc5yzz2810030dyg5hns5f55n7bd3avl";
  };
  installPhase = "python ./setup.py install --prefix $out";
  buildInputs = [ python cups ];
}
