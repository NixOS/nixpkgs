{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage rec {
  pname = "clickhouse-cityhash";
  version = "1.0.2.3";

  src = fetchFromGitHub {
     owner = "xzkostyan";
     repo = "python-cityhash";
     rev = "1.0.2.3";
     sha256 = "0b6w0cp66y5d600srp1hp7ibmywac6aymmldksl8swl5jvb9rffg";
  };

  propagatedBuildInputs = [ setuptools ];

  doCheck = false;
  pythonImportsCheck = [ "clickhouse_cityhash" ];

  meta = with lib; {
    description = "Python-bindings for CityHash, a fast non-cryptographic hash algorithm";
    homepage = "https://github.com/xzkostyan/python-cityhash";
    license = licenses.upl;
    maintainers = with maintainers; [ breakds ];
  };
}
