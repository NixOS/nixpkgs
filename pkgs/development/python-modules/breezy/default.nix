{ lib
, buildPythonPackage
, fetchPypi
, configobj
, patiencediff
, six
, fastimport
, dulwich
, launchpadlib
, testtools
}:

buildPythonPackage rec {
  pname = "breezy";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1eff207403f48898fa3b3ffa7a4275197c6c58fec105ef267caf1f5fd5a6c7be";
  };

  propagatedBuildInputs = [ configobj patiencediff six fastimport dulwich launchpadlib ];

  checkInputs = [ testtools ];

  # There is a conflict with their `lazy_import` and plugin tests
  doCheck = false;

  # symlink for bazaar compatibility
  postInstall = ''
    ln -s "$out/bin/brz" "$out/bin/bzr"
  '';

  pythonImportsCheck = [ "breezy" ];

  meta = with lib; {
    description = "Friendly distributed version control system";
    homepage = "https://www.breezy-vcs.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.marsam ];
  };
}
