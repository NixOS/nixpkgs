{ stdenv
, buildPythonPackage
, fetchPypi
, fetchFromBitbucket
, isPy3k
, pkgs
, python
}:

buildPythonPackage rec {
  pname = "pyhepmc";
  version = "1.0.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1210fd7e20d4abc1d9166147a9f7645a2a58b655fe030ad54ab3ea0d0c6e0834";
  };

  srcMissing = fetchFromBitbucket {
    owner = "andybuckley";
    repo = "pyhepmc";
    rev = "pyhepmc-1.0.0";
    sha256 = "0vxad143pz45q94w5p0dycpk24insdsv1m5k867y56xy24bi0d4w";
  };

  prePatch = ''
    cp -r $srcMissing/hepmc .
    chmod +w hepmc
  '';

  patches = [
    # merge PR https://bitbucket.org/andybuckley/pyhepmc/pull-requests/1/add-incoming-outgoing-generators-for/diff
    ./pyhepmc_export_edges.patch
    # add bindings to Flow class
    ./pyhepmc_export_flow.patch
  ];

  # regenerate python wrapper
  preConfigure = ''
    swig -c++ -I${pkgs.hepmc}/include -python hepmc/hepmcwrap.i
  '';

  nativeBuildInputs = [ pkgs.swig ];
  buildInputs = [ pkgs.hepmc2 ];

  HEPMCPATH = pkgs.hepmc2;

  checkPhase = ''
    ${python.interpreter} test/test1.py
  '';

  meta = with stdenv.lib; {
    description = "A simple wrapper on the main classes of the HepMC event simulation representation, making it possible to create, read and manipulate HepMC events from Python code";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ veprbl ];
  };

}
