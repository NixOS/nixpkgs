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
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4LJo6xoooq8EUoDDfQIa4y1/8XX0ybmfM6rX2wsp2Fw=";
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
