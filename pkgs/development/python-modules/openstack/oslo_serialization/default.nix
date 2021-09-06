{ lib, buildPythonApplication, fetchPypi
, pbr, msgpack, openstack-oslo_utils, pytz
}:

buildPythonApplication rec {
  pname = "openstack-oslo_serialization";
  version = "4.2.0";

  src = fetchPypi {
    pname = "oslo.serialization";
    inherit version;
    sha256 = "3007e1b017ad3754cce54def894054cbcd05887e85928556657434b0fc7e4d83";
  };

  propagatedBuildInputs = [
    pbr
    msgpack
    openstack-oslo_utils
    pytz
  ];

  doCheck = false;

  pythonImportsCheck = [ "oslo_serialization" ];

  meta = with lib; {
    description = "A library providing support for representing objects in transmittable and storable formats, such as Base64, JSON and MessagePack";
    downloadPage = "https://pypi.org/project/oslo.serialization/";
    homepage = "https://github.com/openstack/oslo.serialization/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
