{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyaehw4a1";
  version = "0.3.9";
  format = "setuptools";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "bannhead";
    repo = "pyaehw4a1";
    rev = "v${version}";
    sha256 = "0grs7kiyhzlwqzmw2yxkkglnwjfpimgwxbgp0047rlp3k8md7sjv";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyaehw4a1" ];

  meta = with lib; {
    description = "Python interface for Hisense AEH-W4A1 module";
    homepage = "https://github.com/bannhead/pyaehw4a1";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
