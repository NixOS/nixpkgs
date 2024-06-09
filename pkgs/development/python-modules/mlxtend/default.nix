{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  setuptools,
  pytestCheckHook,
  scipy,
  numpy,
  scikit-learn,
  pandas,
  matplotlib,
  joblib,
}:

buildPythonPackage rec {
  pname = "mlxtend";
  version = "0.23.1";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FlP6UqX/Ejk9c3Enm0EJ0xqy7iOhDlFqjWWxd4VIczQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    scipy
    numpy
    scikit-learn
    pandas
    matplotlib
    joblib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "-sv" ];

  disabledTestPaths = [
    # image tests download files over the network
    "mlxtend/image"
  ];

  meta = with lib; {
    description = "A library of Python tools and extensions for data science";
    homepage = "https://github.com/rasbt/mlxtend";
    license = licenses.bsd3;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
    # incompatible with nixpkgs scikit-learn version
    broken = true;
  };
}
