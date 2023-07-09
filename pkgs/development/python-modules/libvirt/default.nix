{ lib, buildPythonPackage, fetchFromGitLab, pkg-config, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "9.5.0";

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    rev = "v${version}";
    hash = "sha256-DhScwkbyCluLc/V26Y6wbZfzo1WBcLswBVzLCGs0PPs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libvirt lxml ];

  nativeCheckInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://libvirt.org/python.html";
    description = "libvirt Python bindings";
    license = licenses.lgpl2;
    maintainers = [ maintainers.fpletz ];
  };
}
