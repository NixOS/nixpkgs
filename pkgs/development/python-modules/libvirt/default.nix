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
  version = "12.5.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    tag = "v${version}";
    hash = "sha256-AGYu0fKulz6zYiOHExhAf2Dm49nkzvLX3LdnkA5v6oo=";
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

  meta = {
    homepage = "https://libvirt.org/python.html";
    description = "Libvirt Python bindings";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.fpletz ];
  };
}
