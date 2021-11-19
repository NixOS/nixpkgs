{ lib, buildPythonPackage, fetchPypi, cython, pytestCheckHook }:

buildPythonPackage rec {
  pname = "cwcwidth";
  version = "0.1.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1azrphpkcyggg38xvkfb9dpc4xmmm90p02kf8dkqd4d6j5w96aj8";
  };

  nativeBuildInputs = [ cython ];

  checkInputs = [ pytestCheckHook ];
  # Hack needed to make pytest + cython work
  # https://github.com/NixOS/nixpkgs/pull/82410#issuecomment-827186298
  preCheck = ''
    export HOME=$(mktemp -d)
    cp -r $TMP/$sourceRoot/tests $HOME
    pushd $HOME
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
