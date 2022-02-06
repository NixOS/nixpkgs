{ lib
, buildPythonPackage
, fetchFromGitHub
, webcolors
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flux-led";
  version = "0.28.21";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "flux_led";
    rev = version;
    sha256 = "sha256-Vt+vlJlOznGShPUUQUt4zL9ht52TvNWbRRO9v9C0cqg=";
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
