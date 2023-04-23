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
  version = "5.1.1";

  src = fetchPypi {
    pname = "oslo.serialization";
    inherit version;
    hash = "sha256-irvaixdjoGBx/CjF2Km+VHuihfSDDminD/iP4R8Wv0M=";
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
