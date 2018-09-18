{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-x11-client";
  version = "0.0.4.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "11n2m3ipyxb5v0bh098lrc24jjdmfavjbas8r8n3jkzb9953883q";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A X11 client Go bindings for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/go-x11-client;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
