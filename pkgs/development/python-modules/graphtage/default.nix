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
  version = "0.2.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ZazqtrrCsoeJK7acj7Unpl+ZI2JL/khMN2aOSHdCHl0=";
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace "json5==0.9.5" "json5>=0.9.5"
  '';

  pythonImportsCheck = [ "graphtage" ];

  meta = with lib; {
    homepage = "https://github.com/trailofbits/graphtage";
    description = "A utility to diff tree-like files such as JSON and XML";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ veehaitch ];
  };
}
