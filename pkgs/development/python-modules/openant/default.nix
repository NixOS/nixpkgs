{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pyusb
}:

buildPythonPackage rec {
  pname = "openant-unstable";
  version = "2017-02-11";

  src = fetchFromGitHub {
    owner = "Tigge";
    repo = "openant";
    rev = "ed89281e37f65d768641e87356cef38877952397";
    sha256 = "1g81l9arqdy09ijswn3sp4d6i3z18d44lzyb78bwnvdb14q22k19";
  };

  # Removes some setup.py hacks intended to install udev rules.
  # We do the job ourselves in postInstall below.
  postPatch = ''
    sed -i -e '/cmdclass=.*/d' setup.py
  '';

  postInstall = ''
    install -dm755 "$out/etc/udev/rules.d"
    install -m644 resources/ant-usb-sticks.rules "$out/etc/udev/rules.d/99-ant-usb-sticks.rules"
  '';

  propagatedBuildInputs = [ pyusb ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Tigge/openant";
    description = "ANT and ANT-FS Python Library";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
