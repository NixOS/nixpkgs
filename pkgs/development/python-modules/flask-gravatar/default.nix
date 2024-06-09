{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  flask,

  # tests
  pytestCheckHook,
  pygments,
}:

buildPythonPackage rec {
  pname = "flask-gravatar";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "Flask-Gravatar";
    inherit version;
    sha256 = "YGZfMcLGEokdto/4Aek+06CIHGyOw0arxk0qmSP1YuE=";
  };

  patches = [
    (fetchpatch {
      # flask 3.0 compat
      url = "https://github.com/zzzsochi/Flask-Gravatar/commit/d74d70d9695c464b602c96c2383d391b38ed51ac.patch";
      hash = "sha256-tCKkA2io/jhvrh6RhTeEw4AKnIZc9hsqTf2qItUsdjo=";
    })
  ];

  postPatch = ''
    sed -i setup.py \
     -e "s|tests_require=tests_require,||g" \
     -e "s|extras_require=extras_require,||g" \
     -e "s|setup_requires=setup_requires,||g"
    # pep8 is deprecated and cov not needed
    substituteInPlace pytest.ini \
     --replace "--pep8" "" \
     --replace "--cov=flask_gravatar --cov-report=term-missing" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ flask ];

  nativeCheckInputs = [
    pytestCheckHook
    pygments
  ];

  pythonImportsCheck = [ "flask_gravatar" ];

  meta = with lib; {
    homepage = "https://github.com/zzzsochi/Flask-Gravatar";
    description = "Small and simple integration of gravatar into flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gador ];
  };
}
