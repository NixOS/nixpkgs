{ lib
<<<<<<< HEAD
, buildPythonPackage
, fetchPypi

# build-system
, poetry-core

# propagates
, flet-core
, httpx
, oauthlib
, packaging
, typing-extensions
, watchdog
, websocket-client
, websockets

=======
, python3
, buildPythonPackage
, fetchPypi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "flet";
<<<<<<< HEAD
  version = "0.7.4";
=======
  version = "0.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-vFPjN+5wIygtP035odAOSdF9PQe6eXz6CJ9Q0d8ScFo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'httpx = "^0.23' 'httpx = ">=0.23' \
      --replace 'watchdog = "^2' 'watchdog = ">=2'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
=======
    hash = "sha256-EDNATwO2N4jXVC5H1VmXqC9XGTnQo8vLvTEozRYZuj4=";
  };

  patches = [
    ./pyproject.toml.patch
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    flet-core
    typing-extensions
    websocket-client
    watchdog
    oauthlib
    websockets
    httpx
    packaging
  ];

  doCheck = false;

  pythonImportsCheck = [
    "flet"
  ];

  meta = {
    description = "A framework that enables you to easily build realtime web, mobile, and desktop apps in Python";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.heyimnova ];
    mainProgram = "flet";
  };
}
