{ lib
, buildPythonPackage
, fetchFromGitHub
, mac_alias
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ds_store";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "al45tair";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zmhnz110dvisydp5h6s0ry2v9qf4rgr60xhhlak0c66zpvlkkl0";
  };

  propagatedBuildInputs = [ mac_alias ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ds_store" ];

  meta = with lib; {
    homepage = "https://github.com/al45tair/ds_store";
    description = "Manipulate Finder .DS_Store files from Python";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
