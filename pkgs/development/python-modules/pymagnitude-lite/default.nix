{ buildPythonPackage
, fetchFromGitHub
, unittestCheckHook
, pybind11
, lib
, numpy
, lz4
, fasteners
, xxhash
}: buildPythonPackage rec {
  pname = "pymagnitude-lite";
  version = "0.1.143";
  src = fetchFromGitHub {
    owner = "neumi";
    repo = "magnitude";
    rev = "${version}";
    hash = "";
  };

  propagatedBuildInputs = [ numpy lz4 xxhash fasteners ];

  checkInputs = [ unittestCheckHook ];

  unittestFlags = [ "-v" "-s" "tests" ];

  meta = with lib; {
    description = "Magnitude fork that only supports Word2Vec, GloVe and fastText embeddings";
    homepage = "https://github.com/neuml/magnitude";
    license = licenses.mit;
    maintainers = with maintainers; [ ehllie ];
  };
}
