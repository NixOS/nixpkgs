{ lib, buildPythonPackage, fetchFromGitLab, pkg-config, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
  version = "9.1.0";

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    rev = "v${version}";
    sha256 = "sha256-kdWmgmkvI7yaqyFytPnHN6OtF+gsRe58q6AlXFycfQ8=";
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
