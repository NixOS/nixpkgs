{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libusb1,
  pytestCheckHook,
  python,
  pythonOlder,
  setuptools-scm,
  importlib-resources,
  pyusb,
}:

buildPythonPackage rec {
  pname = "libusb-package";
  version = "1.0.26.2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "libusb-package";
    rev = "v${version}";
    hash = "sha256-bM+v3eeQQHiBKsFky51KdDYlRjFzykQFkuFKkluqkjY=";
  };

  patches = [ ./fix-pytest.patch ];

  # Replace the setup to not build libusb
  postPatch = ''
    cp -f ${./setup.py} setup.py
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  buildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    importlib-resources
  ];

  propagatedNativeBuildInputs = [
    libusb1
  ];

  # Symlink the system libusb instead of building it
  postInstall = ''
    ln -fs "${libusb1}/lib/libusb-1.0.so" "$out/${python.sitePackages}/libusb_package/libusb-1.0.so"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    libusb1
  ];

  checkInputs = [
    pyusb
  ];

  pytestFlagsArray = [ "test.py" ];

  pythonImportsCheck = [ "libusb_package" ];

  meta = with lib; {
    homepage = "https://github.com/pyocd/libusb-package";
    description = "Packaged libusb shared libraries for Python";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      vbruegge
      stargate01
    ];
  };
}
