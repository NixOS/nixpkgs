{
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
  version = "10.4.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    rev = "v${version}";
    hash = "sha256-Qwn07C8N2ZZzE5+qCo2HtBSm5/zGBqbiLnJePxuEJjs=";
  };

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
    description = "libvirt Python bindings";
    license = licenses.lgpl2;
    maintainers = [ maintainers.fpletz ];
  };
}
