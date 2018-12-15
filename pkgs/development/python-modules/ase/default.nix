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
  version = "3.17.0";
  pname = "ase";

  src = fetchurl {
     url = "https://gitlab.com/${pname}/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
     sha256 = "0qwy5n1rgn8smg4462634ky0dsd89xxzk2qyrvgdhvalx7nw9632";
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
