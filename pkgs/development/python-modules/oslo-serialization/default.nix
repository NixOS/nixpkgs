{ lib
, buildPythonPackage
, fetchPypi
, msgpack
, oslo-utils
, oslotest
, pbr
, pytz
, stestr
}:

buildPythonPackage rec {
  pname = "oslo-serialization";
<<<<<<< HEAD
  version = "5.2.0";
=======
  version = "5.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "oslo.serialization";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-nPAw1hpszh9Hpi1AUPXoPhvRoQGKxnG7GTruB9Fb28I=";
=======
    hash = "sha256-irvaixdjoGBx/CjF2Km+VHuihfSDDminD/iP4R8Wv0M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ msgpack oslo-utils pytz ];

  nativeCheckInputs = [ oslotest stestr ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_serialization" ];

  meta = with lib; {
    description = "Oslo Serialization library";
    homepage = "https://github.com/openstack/oslo.serialization";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
