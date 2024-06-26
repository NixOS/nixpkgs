{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  fetchpatch,
  mock,
  numpy,
  scipy,
  smart-open,
  testfixtures,
  pyemd,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gensim";
  version = "4.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-maxq9v/UBoLnAVXtn5Lsv0OE1Z+1CvEg00PqXuGzCKs=";
  };

  patches = [
    # https://github.com/piskvorky/gensim/pull/3524
    # Import deprecated scipy.linalg.triu from numpy.triu. remove on next update
    (fetchpatch {
      name = "scipi-linalg-triu-fix.patch";
      url = "https://github.com/piskvorky/gensim/commit/ad68ee3f105fc37cf8db333bfb837fe889ff74ac.patch";
      hash = "sha256-Ij6HvVD8M2amzcjihu5bo8Lk0iCPl3iIq0lcOnI6G2s=";
    })
  ];

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    smart-open
    numpy
    scipy
  ];

  nativeCheckInputs = [
    mock
    pyemd
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gensim" ];

  # Test setup takes several minutes
  doCheck = false;

  pytestFlagsArray = [ "gensim/test" ];

  meta = with lib; {
    description = "Topic-modelling library";
    homepage = "https://radimrehurek.com/gensim/";
    changelog = "https://github.com/RaRe-Technologies/gensim/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ jyp ];
  };
}
