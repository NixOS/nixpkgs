{ stdenv, lib, fetchFromGitLab
}:

stdenv.mkDerivation rec {
  pname = "libbencodetools";
  version = "unstable-2021-04-15";

  src = fetchFromGitLab {
    owner = "heikkiorsila";
    repo = "bencodetools";
    rev = "1ab11f6509a348975e8aec829d7abbf2f8e9b7d1";
    sha256 = "1i2dgvxxwj844yn45hnfx3785ljbvbkri0nv0jx51z4i08w7cz0h";
  };

  postPatch = ''
    patchShebangs .
  '';

  configureFlags = [
    "--without-python"
  ];

  meta = with lib; {
    description = "Collection of tools for manipulating bencoded data";
    homepage = "https://gitlab.com/heikkiorsila/bencodetools";
    license = licenses.bsd2;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.unix;
  };
}
