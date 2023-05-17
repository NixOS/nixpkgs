{ lib
, buildPythonPackage
, ddt
, fetchPypi
, igraph
, igraph-c
, pythonOlder
, setuptools-scm
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "leidenalg";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-flz+O2+A8yuQ9V81xo1KmQsEibEoLPP6usjNpJiJdfM=";
  };

  postPatch = ''
    substituteInPlace ./setup.py \
      --replace "[\"/usr/include/igraph\", \"/usr/local/include/igraph\"]" \
                "[\"${igraph-c.dev}/include/igraph\"]"

    rm -r vendor
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    igraph
    igraph-c
  ];

  checkInputs = [
    ddt
    unittestCheckHook
  ];

  pythonImportsCheck = [ "leidenalg" ];

  meta = with lib; {
    description = "Implementation of the Leiden algorithm for various quality functions to be used with igraph in Python";
    homepage = "https://leidenalg.readthedocs.io";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jboy ];
  };
}
