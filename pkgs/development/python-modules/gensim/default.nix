{
  lib,
  buildPythonPackage,
  cython,
  oldest-supported-numpy,
  setuptools,
  fetchFromGitHub,
  mock,
  numpy_1,
  scipy,
  smart-open,
  pyemd,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gensim";
  version = "4.3.3";
  pyproject = true;

  # The pypi source package fails to build with Cython 3.0, so we get
  # the sources from the repo instead.
  src = fetchFromGitHub {
    owner = "piskvorky";
    repo = "gensim";
    rev = version;
    hash = "sha256-J2DNnu4SmJtAnBZ+D4xUFGDVCj9u2zXMLZlVFWbbSUg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython>=0.29.32,<3.0.0" "Cython"
  '';

  build-system = [
    cython
    (oldest-supported-numpy.override { numpy = numpy_1; })
    setuptools
  ];

  dependencies = [
    smart-open
    numpy_1
    scipy
  ];

  nativeCheckInputs = [
    mock
    pyemd
    pytestCheckHook
  ];

  pythonRelaxDeps = [ "scipy" ];

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
