{ stdenv, fetchFromGitHub, cmake, xtl }:
let version = "0.15.4";
in
stdenv.mkDerivation rec {
  name = "xtensor-${version}";

  src = fetchFromGitHub {
    owner = "QuantStack";
    repo = "xtensor";
    rev = version;
    sha256 = "0q1flbz3h6dsjfqm9avf7f73l0lxjij0md6w161k1qs6lk3sks49";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ xtl ];

  meta = with stdenv.lib; {
    description = "Multi-dimensional arrays with broadcasting and lazy computing";
    homepage = http://quantstack.net/xtensor;
    license = licenses.bsd3;
    maintainers =  with stdenv.lib.maintainers; [ mredaelli ];
  };
}
