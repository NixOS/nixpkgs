{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
, coverage
, nose
, nose-show-skipped
, flake8
, flake8-future-import
, pep8-naming
}:

buildPythonPackage rec {
  pname = "confuse";
  version = "1.0.0";

  # use fetchFromGitHub instead of fetchPypi because
  # "test/__init__.py" is missing in MANIFEST.in
  src = fetchFromGitHub {
    owner = "beetbox";
    repo = pname;
    rev = "1619d3ac33d2959cd5f4aa9ad725935b790ad12f";
    sha256 = "0my2f97da6d1l9xjg3i493xhngrx3d2n8i0hbb2la6d37i7kj5l2";
  };

  propagatedBuildInputs = [ pyyaml ];

  checkInputs = [
    pyyaml
    coverage
    nose
    nose-show-skipped
    flake8
    flake8-future-import
    pep8-naming
  ];

  checkPhase = ''
  nosetests --with-coverage
  nosetests
  '';

  meta = with lib; {
    description = "Painless YAML config files for Python";
    homepage = "https://github.com/beetbox/confuse";
    maintainers = with maintainers; [ melsigl ];
    license = licenses.mit;
  };
}
