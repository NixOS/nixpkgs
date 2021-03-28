{ lib, stdenv
, fetchFromGitHub
, python
, pyusb
}:

stdenv.mkDerivation rec {
  pname = "py3buddy";
  version = "unstable-2019-09-29";

  src = fetchFromGitHub {
    owner = "armijnhemel";
    repo = pname;
    rev = "2b28908454645117368ca56df67548c93f4e0b03";
    sha256 = "12ar4kbplavndarkrbibxi5i607f5sfia5myscvalqy78lc33798";
  };

  propagatedBuildInputs = [ pyusb ];

  dontConfigure = true;
  dontBuild = true;
  dontCheck = true;

  installPhase = ''
    install -D py3buddy.py $out/${python.sitePackages}/py3buddy.py
  '';

  postInstall = ''
    install -D 99-ibuddy.rules $out/lib/udev/rules.d/99-ibuddy.rules
  '';

  meta = with lib; {
    description = "Code to work with the iBuddy MSN figurine";
    homepage = "https://github.com/armijnhemel/py3buddy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ prusnak ];
  };
}
