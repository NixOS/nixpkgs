{ lib, buildPythonPackage, fetchFromGitLab, pkg-config, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "7.2.0";

  src = assert version == libvirt.version; fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    rev = "v${version}";
    sha256 = "sha256-GW3U/jDO4XBuoGldPER0+ljxQnAESfteP8JwU70nSss=";
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
