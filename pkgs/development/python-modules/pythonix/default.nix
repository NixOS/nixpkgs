{ stdenv, buildPythonPackage, fetchFromGitHub, ninja, boost, meson, pkgconfig, nix, isPy3k }:

buildPythonPackage rec {
  pname = "pythonix";
  version = "0.1.6";
  format = "other";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "pythonix";
    rev = "v${version}";
    sha256 = "1qzcrpn333hsgn6fj1m1s3cvaf0ny8qpygamcrazqv57xmwyr8h5";
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
