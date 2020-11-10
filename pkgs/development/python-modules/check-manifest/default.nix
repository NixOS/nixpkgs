{ stdenv, buildPythonPackage, fetchPypi, pep517, toml, mock, breezy, git }:

buildPythonPackage rec {
  pname = "check-manifest";
  version = "0.42";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d8e1b0944a667dd4a75274f6763e558f0d268fde2c725e894dfd152aae23300";
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
