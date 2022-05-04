{ lib
, buildPythonPackage
, fetchFromGitHub
, webcolors
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flux-led";
  version = "0.28.28";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "flux_led";
    rev = version;
    sha256 = "sha256-FtZHZ48XGo+0aP4ARSfzI9xzFVptYhG6CDVGTT4oDBQ=";
  };

  propagatedBuildInputs = [
    webcolors
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner>=5.2",' ""
  '';

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "flux_led"
  ];

  meta = with lib; {
    description = "Python library to communicate with the flux_led smart bulbs";
    homepage = "https://github.com/Danielhiversen/flux_led";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.linux;
  };
}
