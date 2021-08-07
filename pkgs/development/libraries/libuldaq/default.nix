{ lib, stdenv, fetchFromGitHub, autoreconfHook, libusb1, ...}:

stdenv.mkDerivation rec {
  pname = "libuldaq";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mccdaq";
    repo = "uldaq";
    rev = "v${version}";
    sha256 = "0l9ima8ac99yd9vvjvdrmacm95ghv687wiy39zxm00cmghcfv3vj";
  };

  patches = [
    # Patch needed for `make install` to succeed
    ./0001-uldaq.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "Library to talk to uldaq devices";
    longDescription = ''
      Library used to communicate with USB data acquisition (DAQ)
      devices from Measurement Computing
    '';
    homepage = "https://github.com/mccdaq/uldaq";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.simonkampe ];
  };
}
