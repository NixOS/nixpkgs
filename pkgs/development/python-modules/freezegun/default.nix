{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, python-dateutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "freezegun";
  version = "1.1.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "177f9dd59861d871e27a484c3332f35a6e3f5d14626f2bf91be37891f18927f3";
  };

  patches = [
    (fetchpatch {
      # https://github.com/spulec/freezegun/issues/396
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-python/freezegun/files/freezegun-1.1.0-py310.patch?id=d030418412529d09801fc2fda2201e525c25ad2d";
      sha256 = "sha256:1ybxqbsn3cz2w25x9wwxi0kzfn9q5ldagb1crbhxy25wyw8s1801";
    })
  ];

  propagatedBuildInputs = [ python-dateutil ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "FreezeGun: Let your Python tests travel through time";
    homepage = "https://github.com/spulec/freezegun";
    license = licenses.asl20;
  };

}
