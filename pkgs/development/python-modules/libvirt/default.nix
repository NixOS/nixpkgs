{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  pkg-config,
  lxml,
  libvirt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libvirt";
  version = "12.4.0";
  pyproject = true;

  # @r-ryantm should not try to automatically update this package. Instead,
  # @r-ryantm should run the update script for the libvirt package. (See the
  # below comment that’s about enableDefaultUpdateScript).
  #
  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    tag = "v${version}";
    hash = "sha256-8+o3ji7b0PCGxnHbsUJTUn1oudeN3rV+ehUILmufD1M=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'pkg-config' "${stdenv.cc.targetPrefix}pkg-config"
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libvirt
    lxml
  ];

  pythonImportsCheck = [ "libvirt" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # This next line prevents the python3Packages.libvirt package from
  # automatically having an update script. If you would like to update the
  # python3Packages.libvirt package, then please run the libvirt package’s
  # update script. The libvirt package’s update script will update the libvirt
  # package, the python3Packages.libvirt package and the perlPackages.SysVirt
  # package.
  enableDefaultUpdateScript = false;

  meta = {
    homepage = "https://libvirt.org/python.html";
    description = "Libvirt Python bindings";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.fpletz ];
  };
}
