{ lib
, buildPythonPackage
, fetchPypi
, configobj
, six
, fastimport
, dulwich
, launchpadlib
, testtools
}:

buildPythonPackage rec {
  pname = "breezy";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50f16bc7faf299f98fe58573da55b0664078f94b1a0e7f0ce9e1e6a0d47e68e0";
  };

  propagatedBuildInputs = [ configobj six fastimport dulwich launchpadlib ];

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
