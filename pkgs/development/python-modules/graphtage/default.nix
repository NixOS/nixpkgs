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
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-rzX5pSSPm3CjpnCm0gxsgUaeXho9dP7WTanCzBK6Yps=";
=======
    hash = "sha256-3PJSjK8citdsfTyTLtDOlLeXWhkOW/4ajLC+j8F0BZw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
