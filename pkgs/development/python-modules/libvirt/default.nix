{ lib, buildPythonPackage, fetchFromGitLab, pkg-config, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "10.0.0";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    rev = "v${version}";
    hash = "sha256-zl1Hfm7flRflNjIpLoLAlPDysYlieC05HEd/mzFW8pU=";
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
