{ lib
, breezy
, build
, buildPythonPackage
, fetchPypi
, git
, mock
, pep517
, pytestCheckHook
, toml
}:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.46";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5895e42a012989bdc51854a02c82c8d6898112a4ab11f2d7878200520b49d428";
  };

  # Test requires filesystem access
  postPatch = ''
    substituteInPlace tests.py --replace "test_build_sdist" "no_test_build_sdist"
  '';

  propagatedBuildInputs = [
    build
    pep517
    toml
  ];

  checkInputs = [
    breezy
    git
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "check_manifest" ];

  meta = with lib; {
    homepage = "https://github.com/mgedmin/check-manifest";
    description = "Check MANIFEST.in in a Python source package for completeness";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
