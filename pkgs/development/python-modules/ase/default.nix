{ lib
, fetchurl
, buildPythonPackage
, numpy
, scipy
, matplotlib
, flask
, pillow
, psycopg2
}:

buildPythonPackage rec {
  version = "3.16.2";
  pname = "ase";

  src = fetchurl {
     url = "https://gitlab.com/${pname}/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
     sha256 = "171j3f4a261cfnqjq98px5fldxql65i3jgf60wc945xvh0mbc8ds";
  };

  propagatedBuildInputs = [ numpy scipy matplotlib flask pillow psycopg2 ];

  checkPhase = ''
    $out/bin/ase test
  '';

  # tests just hang most likely due to something with subprocesses and cli
  doCheck = false;

  meta = {
    description = "Atomic Simulation Environment";
    homepage = https://wiki.fysik.dtu.dk/ase/;
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
