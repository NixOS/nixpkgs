{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cwcwidth";
  version = "0.1.9";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Z0RoBSNSoys0GTJbpO8qM40FaGGroIEA49F4Qjbdrg=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  preCheck = ''
    # Hack needed to make pytest + cython work
    # https://github.com/NixOS/nixpkgs/pull/82410#issuecomment-827186298
    export HOME=$(mktemp -d)
    cp -r $TMP/$sourceRoot/tests $HOME
    pushd $HOME

    # locale settings used by upstream, has the effect of skipping
    # otherwise-failing tests on darwin
    export LC_ALL='C.UTF-8'
    export LANG='C.UTF-8'
  '';
  postCheck = "popd";

  pythonImportsCheck = [ "cwcwidth" ];

  meta = with lib; {
    description = "Python bindings for wc(s)width";
    homepage = "https://github.com/sebastinas/cwcwidth";
    changelog = "https://github.com/sebastinas/cwcwidth/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
