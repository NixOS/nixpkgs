{ stdenv, fetchFromGitHub, cmake, zeromq }:

stdenv.mkDerivation rec {
  name = "cppzmq-${version}";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "v${version}";
    sha256 = "0hy8yxb22siimq0pf6jq6kdp9lvi5f6al1xd12c9i1jyajhp1lhk";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zeromq ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zeromq/cppzmq;
    license = licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
