{ stdenv
, fetchFromGitHub
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "mutest";
  version = "unstable-2019-10-12";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = "mutest";
    rev = "822b5ddf07f957135ba39889d81e513d525b9b8e";
    sha256 = "0a5fjdq9p0q5bibqngbbpd9lga0gzrv8yj5wgdfb8ylxzg0jph2p";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://ebassi.github.io/mutest/mutest.md.html;
    description = "A BDD testing framework for C, inspired by Mocha";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar worldofpeace ];
    platforms = platforms.all;
  };
}
