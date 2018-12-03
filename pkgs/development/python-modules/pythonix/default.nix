{ stdenv, buildPythonPackage, fetchFromGitHub, ninja, boost, meson, pkgconfig, nix, isPy3k }:

buildPythonPackage rec {
  pname = "pythonix";
  version = "0.1.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "pythonix";
    rev = "v${version}";
    sha256 = "1q1fagfwzvmcm1n3a0liay7m5krazmhw9l001m90rrz2x7vrsqwk";
  };

  disabled = !isPy3k;

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ nix boost ];

  meta = with stdenv.lib; {
    description = ''
       Eval nix code from python.
    '';
    maintainers = [ maintainers.mic92 ];
    license = licenses.mit;
  };
}
