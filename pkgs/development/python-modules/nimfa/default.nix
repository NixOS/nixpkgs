{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  numpy,
  scipy,
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nimfa";
  version = "1.4.0";
  format = "setuptools";
  setuptools = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oc/yuGhW0Dyoo9nDhZgDTs8adowyX9OnKLuerbjGuRk=";
  };

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    matplotlib
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "import imp" "" \
      --replace-fail "os.path.exists('.git')" "True" \
      --replace-fail "GIT_REVISION = git_version()" "GIT_REVISION = 'v${version}'"
  '';

  doCheck = !isPy3k; # https://github.com/marinkaz/nimfa/issues/42

  meta = {
    description = "Nonnegative matrix factorization library";
    homepage = "http://nimfa.biolab.si";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
