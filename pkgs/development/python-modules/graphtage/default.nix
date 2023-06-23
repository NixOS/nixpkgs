{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
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
  version = "0.2.8";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qp3NMN/aeWhr4z6qqh/s4OHebQccyIjSzWIy7P1RruI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "json5==0.9.5" "json5>=0.9.5"
  '';

  propagatedBuildInputs = [
    colorama
    intervaltree
    json5
    pyyaml
    scipy
    tqdm
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "graphtage"
  ];

  meta = with lib; {
    description = "A utility to diff tree-like files such as JSON and XML";
    homepage = "https://github.com/trailofbits/graphtage";
    changelog = "https://github.com/trailofbits/graphtage/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ veehaitch ];
  };
}
