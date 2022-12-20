{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, protobuf
}:

buildPythonPackage rec {
  pname = "biliass";
  version = "1.3.7";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-P7K3bt8MXD6HoJ7duQ9lG99yj0lVwn9SqEEC/TUudK4=";
  };

  postPatch = ''
    sed -i -e 's/4.21.9/4.21.8/' setup.py
  '';

  propagatedBuildInputs = [ protobuf ];

  pythonImportsCheck = [ "biliass" ];

  meta = with lib; {
    homepage = "https://github.com/yutto-dev/biliass";
    description = "Convert Bilibili XML/protobuf danmaku to ASS subtitle";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
  };
}
