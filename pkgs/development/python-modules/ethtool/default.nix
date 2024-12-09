{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  pkg-config,
  libnl,
  nettools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ethtool";
  version = "0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fedora-python";
    repo = "python-ethtool";
    rev = "refs/tags/v${version}";
    hash = "sha256-0XzGaqpkEv3mpUsbfOtRl8E62iNdS7kRoo4oYrBjMys=";
  };

  patches = [
    # https://github.com/fedora-python/python-ethtool/pull/60
    (fetchpatch2 {
      url = "https://github.com/fedora-python/python-ethtool/commit/f82dd763bd50affda993b9afe3b141069a1a7466.patch";
      hash = "sha256-mtI7XsoyM43s2DFQdsBNpB8jJff7ZyO2J6SHodBrdrI=";
    })
  ];

  postPatch = ''
    substituteInPlace tests/parse_ifconfig.py \
      --replace-fail "Popen('ifconfig'," "Popen('${lib.getExe' nettools "ifconfig"}',"
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libnl ];

  pythonImportsCheck = [ "ethtool" ];

  nativeCheckInputs = [
    nettools
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/fedora-python/python-ethtool/blob/${src.rev}/CHANGES.rst";
    description = "Python bindings for the ethtool kernel interface";
    homepage = "https://github.com/fedora-python/python-ethtool";
    license = licenses.gpl2Plus;
  };
}
