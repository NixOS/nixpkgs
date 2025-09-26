{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "defusedcsv";
  version = "3.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "defusedcsv";
    tag = "v${version}";
    hash = "sha256-OEDZbltnh2tAM58Kk852W0so7oOSv7S+S046MjIOMfY=";
  };

  pythonImportsCheck = [ "defusedcsv.csv" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python library to protect your users from Excel injections in CSV-format exports, drop-in replacement for standard library's csv module";
    homepage = "https://github.com/raphaelm/defusedcsv";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
