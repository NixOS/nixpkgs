{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, protobuf
}:

buildPythonPackage rec {
  pname = "biliass";
  version = "1.3.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kgoQUX2l5YENEozcnfluwvcAO1ZSxlfHPVIa9ABW6IU=";
  };

  propagatedBuildInputs = [ protobuf ];

  pythonImportsCheck = [ "biliass" ];

  meta = with lib; {
    homepage = "https://github.com/yutto-dev/biliass";
    description = "Convert Bilibili XML/protobuf danmaku to ASS subtitle";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
  };
}
