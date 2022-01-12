{ lib
, buildPythonPackage
, envoy-utils
, fetchFromGitHub
, fetchpatch
, httpx
, pytest-asyncio
, pytest-raises
, pytestCheckHook
, respx
}:

buildPythonPackage rec {
  pname = "envoy-reader";
  version = "0.20.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jesserizzo";
    repo = "envoy_reader";
    rev = version;
    sha256 = "sha256-nPB1Fvb1qwLHeFkXP2jXixD2ZGA09MtS1qXRhYGt0fM=";
  };

  propagatedBuildInputs = [
    envoy-utils
    httpx
  ];

  checkInputs = [
    pytest-raises
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner>=5.2" ""
  '';

  patches = [
    # Support for later httpx, https://github.com/jesserizzo/envoy_reader/pull/82
    (fetchpatch {
      name = "support-later-httpx.patch";
      url = "https://github.com/jesserizzo/envoy_reader/commit/6019a89419fe9c830ba839be7d39ec54725268b0.patch";
      sha256 = "17vsrx13rskvh8swvjisb2dk6x1jdbjcm8ikkpidia35pa24h272";
    })
  ];

  pythonImportsCheck = [
    "envoy_reader"
  ];

  meta = with lib; {
    description = "Python module to read from Enphase Envoy units";
    homepage = "https://github.com/jesserizzo/envoy_reader";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
