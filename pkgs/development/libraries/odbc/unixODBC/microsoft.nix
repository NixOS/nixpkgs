{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "unixODBC-MSSQL-${version}";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "unixODBC-MSSQL";
    rev = "cb2d51475125c2c1817808dbc02e850bd29af1c0";
    sha256 = "06qlvjhkjb6d55xsy6yminjarv5cbak8nwk9lvwfs8f4l9xiz6v1";
  };

  postPatch = ''
    chmod +x ./configure
  '';

  configureFlags = [ "--disable-gui" "--sysconfdir=/etc" ];

  meta = with stdenv.lib; {
    description = "Microsoft fork of the ODBC driver manager for Unix";
    homepage = http://www.unixodbc.org/;
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}
