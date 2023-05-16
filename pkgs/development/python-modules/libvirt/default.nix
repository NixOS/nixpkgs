{ lib, buildPythonPackage, fetchFromGitLab, pkg-config, lxml, libvirt, nose }:

buildPythonPackage rec {
  pname = "libvirt";
<<<<<<< HEAD
  version = "9.7.0";
=======
  version = "9.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "libvirt";
    repo = "libvirt-python";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-DFZPZx+jkxdNha+h50IXxl6wOwA1VjudRICgxD2V4+k=";
=======
    hash = "sha256-htJPNFiY0WuQlgfFkLh3RUmnx2X4aQ0+iUQgZ1+HDp0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
