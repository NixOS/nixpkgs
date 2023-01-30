{ lib
, buildPythonPackage
, fetchPypi
, linuxHeaders
, pythonOlder
}:

buildPythonPackage rec {
  pname = "evdev";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7PoBtchPfoxs7TNnrJUoj0PNhO+/1919DNv8DRjIemo=";
  };

  buildInputs = [
    linuxHeaders
  ];

  patchPhase = ''
    substituteInPlace setup.py \
      --replace /usr/include/linux ${linuxHeaders}/include/linux
  '';

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
