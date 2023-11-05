{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "multi-key-dict";
  version = "2.0.3";

  src = fetchPypi {
    pname = "multi_key_dict";
    inherit version;
    sha256 = "17lkx4rf4waglwbhc31aak0f28c63zl3gx5k5i1iq2m3gb0xxsyy";
  };

  meta = with lib; {
    description = "multi_key_dict";
    homepage = "https://github.com/formiaczek/multi_key_dict";
    license = licenses.mit;
  };

}
