{ lib
, buildPythonPackage
, fetchPypi
, msgpack
, greenlet
, pythonOlder
, isPyPy
}:

buildPythonPackage rec {
  pname = "pynvim";
  version = "0.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OnlTeL3l6AkvvrOhqZvpxhPSaFVC8dsOXG/UZ+7Vbf8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace " + pytest_runner" ""
  '';

  propagatedBuildInputs = [
    msgpack
  ] ++ lib.optionals (!isPyPy) [
    greenlet
  ];

  # Tests require pkgs.neovim which we cannot add because of circular dependency
  doCheck = false;

  pythonImportsCheck = [
    "pynvim"
  ];

  meta = with lib; {
    description = "Python client for Neovim";
    homepage = "https://github.com/neovim/pynvim";
    changelog = "https://github.com/neovim/pynvim/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
