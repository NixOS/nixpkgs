{ stdenv, lib, fetchFromGitHub, libX11}:

stdenv.mkDerivation rec {
  version = "0.2.3";
  pname = "libspnav";

  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = "libspnav";
    rev = "${pname}-${version}";
    sha256 = "098h1jhlj87axpza5zgy58prp0zn94wyrbch6x0s7q4mzh7dc8ba";
  };

  buildInputs = [ libX11 ];

  configureFlags = [ "--disable-debug"];

  preInstall = ''
    mkdir -p $out/{lib,include}
  '';

  meta = with lib; {
    homepage = "http://spacenav.sourceforge.net/";
    description = "Device driver and SDK for 3Dconnexion 3D input devices";
    longDescription = "A free, compatible alternative, to the proprietary 3Dconnexion device driver and SDK, for their 3D input devices (called 'space navigator', 'space pilot', 'space traveller', etc)";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sohalt ];
  };
}
