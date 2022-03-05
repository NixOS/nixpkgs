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
  version = "0.47";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56dadd260a9c7d550b159796d2894b6d0bcc176a94cbc426d9bb93e5e48d12ce";
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
