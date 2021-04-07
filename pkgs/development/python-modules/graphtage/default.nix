{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, pythonOlder
  # Python dependencies
, colorama
, intervaltree
, json5
, pyyaml
, scipy
, tqdm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "graphtage";
  version = "0.2.5";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cFOTbPv7CnRdet7bx5LVq5xp9LG4yNm0oxlW5aSEeZs=";
  };

  propagatedBuildInputs = [
    colorama
    intervaltree
    json5
    pyyaml
    scipy
    tqdm
    typing-extensions
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "graphtage" ];

  meta = with lib; {
    homepage = "https://github.com/trailofbits/graphtage";
    description = "A utility to diff tree-like files such as JSON and XML";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ veehaitch ];
  };
}
