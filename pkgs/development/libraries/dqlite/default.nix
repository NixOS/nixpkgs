{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file, libco-canonical
, libuv, raft-canonical, sqlite-replication }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "v${version}";
    sha256 = "0670c1c84lcf5vl3h6mlff00fz2fnm766bzlk526sjjzysx3zjya";
  };

  nativeBuildInputs = [ autoreconfHook file pkgconfig ];
  buildInputs = [ libco-canonical.dev libuv raft-canonical.dev 
                  sqlite-replication ];

  preConfigure= ''
    substituteInPlace configure --replace /usr/bin/ " "
  '';

  doCheck = true;

  outputs = [ "dev" "out" ];

  meta = {
    description = ''
      Expose a SQLite database over the network and replicate it across a
      cluster of peers
    '';
    homepage = https://github.com/CanonicalLtd/dqlite/;
    license = licenses.asl20;
    maintainers = with maintainers; [ joko ];
    platforms = platforms.unix;
  };
}
