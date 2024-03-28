{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, cython
, archspec
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyrodigal";
  version = "2.2.0";

  format = "setuptools";

  src = fetchPypi {
    pname = "pyrodigal";
    inherit version;
    hash = "sha256-1RZXeqb4F3ryDRdsB1e7zhc2Ha+1z/wosqMs/xJWwyU=";
  };

  propagatedBuildInputs = [ archspec ];

  nativeBuildInputs = [ cython ];

  doCheck = false;

  pythonImportsCheck = [ "pyrodigal" ];

  sandboxProfile = ''
    # Used by archspec to detect the CPU when importing pyrodigal.
    (allow process-exec (literal "/usr/sbin/sysctl"))
  '';

  meta = {
    description = "Cython bindings and Python interface to Prodigal, an ORF finder for genomes and metagenomes";
    homepage = "https://github.com/althonos/pyrodigal";
    license = lib.licenses.gpl3Only;
    changelog = "https://github.com/althonos/pyrodigal/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ thyol ];
  };
}
