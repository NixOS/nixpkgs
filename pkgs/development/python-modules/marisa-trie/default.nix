{ lib
, buildPythonPackage
, fetchPypi
, pytestrunner
, pytest
, hypothesis
}:

buildPythonPackage rec {
  pname = "marisa-trie";
  version = "0.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n4pxnaranbh3x2fcqxwh8j1z2918vy7i4q1z4jn75m9rkm5h8ia";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "hypothesis==" "hypothesis>="
  '';

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [ pytest hypothesis ];

  meta = with lib; {
    description = "Static memory-efficient Trie-like structures for Python (2.x and 3.x) based on marisa-trie C++ library";
    longDescription = "There are official SWIG-based Python bindings included in C++ library distribution; this package provides alternative Cython-based pip-installable Python bindings.";
    homepage =  https://github.com/kmike/marisa-trie;
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
