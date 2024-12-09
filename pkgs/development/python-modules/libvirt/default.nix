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
  version = "10.10.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    rev = "v${version}";
    hash = "sha256-zOjTGXwxjd6QT01AaIln0FdP/8UZS0W3yPltUhlocpk=";
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
