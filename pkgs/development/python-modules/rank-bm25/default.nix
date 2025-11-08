{
  lib,
  buildPythonPackage,
  pythonOlder,
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
    repo = "rank-bm25";
    rev = version;
    hash = "sha256-+BxQBflMm2AvCLAFFj52Jpkqn+KErwYXU1wztintgOg=";
  };

  disabled = pythonOlder "3.7";

  postPatch = ''
    # Upstream doesn't provide a PKG-INFO file
    substituteInPlace setup.py --replace "get_version()" "'${version}'"
  '';

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "rank_bm25" ];

  meta = with lib; {
    description = "Collection of BM25 Algorithms in Python";
    homepage = "https://github.com/dorianbrown/rank_bm25";
    changelog = "https://github.com/dorianbrown/rank_bm25/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
