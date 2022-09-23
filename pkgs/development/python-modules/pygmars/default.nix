{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygmars";
  version = "0.7.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wghk4nzplpl26iwrgvm0n9x88nyxlcxz4ywss4nwdr4hfccl28l";
  };

  dontConfigure = true;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pygmars"
  ];

  meta = with lib; {
    description = "Python lexing and parsing library";
    homepage = "https://github.com/nexB/pygmars";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
