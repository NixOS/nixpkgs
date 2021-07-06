{ lib
, buildPythonPackage
, fetchFromGitHub
, protobuf
}:

buildPythonPackage rec {
  pname = "pycomfoconnect";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "michaelarnauts";
    repo = "comfoconnect";
    rev = version;
    sha256 = "0bipzv68yw056iz9m2g9h40hzrwd058a7crxp0xbq4rw2d8j0jn6";
  };

  propagatedBuildInputs = [
    protobuf
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pycomfoconnect" ];

  meta = with lib; {
    description = "Python module to interact with ComfoAir Q350/450/600 units";
    homepage = "https://github.com/michaelarnauts/comfoconnect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
