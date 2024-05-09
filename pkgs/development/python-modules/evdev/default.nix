{ lib
, buildPythonPackage
, fetchPypi
, linuxHeaders
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lb0qHgxs4s16LsxubNlzb/eUs61ctU2B2MvC5BTQuHA=";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace-fail /usr/include ${linuxHeaders}/include
  '';

  build-system = [
    setuptools
  ];

  buildInputs = [
    linuxHeaders
  ];

  doCheck = false;

  pythonImportsCheck = [
    "evdev"
  ];

  meta = with lib; {
    description = "Provides bindings to the generic input event interface in Linux";
    homepage = "https://python-evdev.readthedocs.io/";
    changelog = "https://github.com/gvalkov/python-evdev/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
