{stdenv, fetchurl, python, cups}:

stdenv.mkDerivation {
  name = "pycups-1.9.48";
  src = fetchurl {
    url = http://cyberelk.net/tim/data/pycups/pycups-1.9.48.tar.bz2;
    sha256 = "11cz6pqp18wxrzpix55pin97mfcmdc4g13zpr739glb6c9mnj7qp";
  };
  installPhase = "python ./setup.py install --prefix $out";
  buildInputs = [ python cups ];
}
