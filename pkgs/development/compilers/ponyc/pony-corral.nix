{ stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation ( rec {
  pname = "corral";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = version;
    sha256 = "0kydx4psl6k4n46as9xc5xwbwapibm6g7haxds7y9d392807qfqk";
  };

  buildInputs = [ ponyc ];

  installFlags = [ "prefix=${placeholder "out"}" "install" ];

  meta = with stdenv.lib; {
    description = "Corral is a dependency management tool for ponylang (ponyc)";
    homepage = "https://www.ponylang.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ redvers ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
})
