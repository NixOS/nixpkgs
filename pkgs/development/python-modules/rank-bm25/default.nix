{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
}:
let
  pname = "rank-bm25";
  version = "0.2.2";
in
buildPythonPackage {
  inherit version pname;
  format = "setuptools";

  # Pypi source package doesn't contain tests
  src = fetchFromGitHub {
    owner = "dorianbrown";
    repo = "rank_bm25";
    tag = version;
    hash = "sha256-+BxQBflMm2AvCLAFFj52Jpkqn+KErwYXU1wztintgOg=";
  };

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    substituteInPlace setup.py --replace "get_version()" "'${version}'"
  '';

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "rank_bm25" ];

  meta = {
    description = "Collection of BM25 Algorithms in Python";
    homepage = "https://github.com/dorianbrown/rank_bm25";
    changelog = "https://github.com/dorianbrown/rank_bm25/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
