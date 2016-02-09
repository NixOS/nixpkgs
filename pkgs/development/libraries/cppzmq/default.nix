{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cppzmq-20151203";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "cppzmq";
    rev = "7f7c83411d83eafe57ae6ffc2972ad9455ac258e";
    sha256 = "1h6fl7mgkv98gz0csbp525a4bp1w9nwm059gwmmv1wqc1l741pv7";
  };

  installPhase = ''
    install -Dm644 zmq.hpp $out/include/zmq.hpp
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/zeromq/cppzmq;
    license = licenses.bsd2;
    description = "C++ binding for 0MQ";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
