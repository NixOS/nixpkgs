{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, six
}:

buildPythonPackage rec {
  pname = "bson";
  version = "0.5.10";

  src = fetchFromGitHub {
     owner = "py-bson";
     repo = "bson";
     rev = "0.5.10";
     sha256 = "1vpy4rsvm3hhawvbg9rbw4j36ck8qylkhm8cjy0q6imvinkd2als";
  };

  propagatedBuildInputs = [
    python-dateutil
    six
  ];

  # 0.5.10 was not tagged, https://github.com/py-bson/bson/issues/108
  doCheck = false;

  pythonImportsCheck = [ "bson" ];

  meta = with lib; {
    description = "BSON codec for Python";
    homepage = "https://github.com/py-bson/bson";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
