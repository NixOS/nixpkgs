{ stdenv, fetchFromGitHub, ninja, meson, pkgconfig, nixUnstable, isPy3k }:

assert isPy3k;

stdenv.mkDerivation rec {
  name = "pythonix-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "pythonix";
    rev = "v${version}";
    sha256 = "1piblysypyr442a6najk4mdh87xc377i2fdbfw6fr569z60mnnnj";
  };

  nativeBuildInputs = [ meson pkgconfig ninja ];

  buildInputs = [ nixUnstable ];

  meta = with stdenv.lib; {
    description = ''
       Eval nix code from python.
    '';
    maintainers = [ maintainers.mic92 ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
