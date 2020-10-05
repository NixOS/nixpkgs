{ stdenv, buildPythonPackage, fetchPypi, pep517, toml, mock, breezy, git }:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.44";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d09db87162a70aa2877660c0ac1a1153e62b8e69bbde5e6155af7507e417af1";
  };

  # Test requires filesystem access
  postPatch = ''
    substituteInPlace tests.py --replace "test_build_sdist" "no_test_build_sdist"
  '';

  propagatedBuildInputs = [ pep517 toml ];

  checkInputs = [ mock breezy git ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mgedmin/check-manifest";
    description = "Check MANIFEST.in in a Python source package for completeness";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo ];
  };
}
