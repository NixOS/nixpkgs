{ lib, buildPythonPackage, fetchFromGitLab, pkg-config, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "8.6.0";

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    rev = "v${version}";
    sha256 = "sha256-eJ0RPxJ4Gm+VGs6NeTWP2FbvDnJy4mURPlFbgvkSgo0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libvirt lxml ];

  checkInputs = [ nose ];
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
