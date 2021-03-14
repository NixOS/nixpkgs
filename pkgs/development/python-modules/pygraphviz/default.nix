{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, substituteAll
, graphviz
, coreutils
, pkg-config
, pytest
}:

buildPythonPackage rec {
  pname = "pygraphviz";
  version = "1.7";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7bec6609f37cf1e64898c59f075afd659106cf9356c5f387cecaa2e0cdb2304";
    extension = "zip";
  };

  patches = [
    # pygraphviz depends on graphviz executables and wc being in PATH
    (substituteAll {
      src = ./path.patch;
      path = lib.makeBinPath [ graphviz coreutils ];
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ graphviz ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest --pyargs pygraphviz
  '';

  meta = with lib; {
    description = "Python interface to Graphviz graph drawing package";
    homepage = "https://github.com/pygraphviz/pygraphviz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasbeyer dotlambda ];
  };
}
