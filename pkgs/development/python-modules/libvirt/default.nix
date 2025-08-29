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
  version = "11.6.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    tag = "v${version}";
    hash = "sha256-YitfYz+g3asMmwTBFTFR9pL+HDBDwI50ZThrgoIb+xQ=";
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

  meta = with lib; {
    homepage = "https://libvirt.org/python.html";
    description = "Libvirt Python bindings";
    license = licenses.lgpl2;
    maintainers = [ maintainers.fpletz ];
  };
}
