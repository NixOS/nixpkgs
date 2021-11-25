{ lib, buildPythonApplication, fetchPypi
, cbor2
, python-dateutil
, pyyaml
, tomlkit
, u-msgpack-python
}:

buildPythonApplication rec {
  pname = "remarshal";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16425aa1575a271dd3705d812b06276eeedc3ac557e7fd28e06822ad14cd0667";
  };

  propagatedBuildInputs = [
    pyyaml cbor2 python-dateutil tomlkit u-msgpack-python
  ];

  meta = with lib; {
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = "https://github.com/dbohdan/remarshal";
    maintainers = with maintainers; [ offline ];
  };
}
