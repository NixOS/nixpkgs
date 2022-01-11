{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "metal";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "brunocodutra";
    repo = "metal";
    rev = "v${version}";
    sha256 = "sha256-1I+EZtIz/2y4+dJGBONhTlUQGHgRdvXc1ZAOC9pmStw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Single-header C++11 library designed to make you love template metaprogramming";
    homepage = "https://github.com/brunocodutra/metal";
    license = licenses.mit;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.all;
  };

}
