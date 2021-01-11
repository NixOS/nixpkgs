{ lib, stdenv, buildPythonPackage, fetchPypi, pep517, toml, mock, breezy, git }:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.45";

  src = fetchPypi {
    inherit pname version;
    sha256 = "636b65a3b685374ad429ff22fe213966765b145f08bc560c8d033b604c7bee4c";
  };

  # Test requires filesystem access
  postPatch = ''
    substituteInPlace tests.py --replace "test_build_sdist" "no_test_build_sdist"
  '';

  propagatedBuildInputs = [ pep517 toml ];

  checkInputs = [ mock breezy git ];

  meta = with lib; {
    homepage = "https://github.com/mgedmin/check-manifest";
    description = "Check MANIFEST.in in a Python source package for completeness";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
