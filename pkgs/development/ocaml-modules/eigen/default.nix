{ stdenv, buildDunePackage, fetchFromGitHub, ctypes }:

buildDunePackage rec {
  pname = "eigen";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "owlbarn";
    repo   = pname;
    rev    = version;
    sha256 = "0pbqd87i9h7qpx84hr8k4iw0rhmjgma4s3wihxh992jjvsrgdyfi";
  };

  minimumOCamlVersion = "4.04";

  propagatedBuildInputs = [ ctypes ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Minimal/incomplete Ocaml interface to Eigen3, mostly for Owl";
    platforms = platforms.x86_64;
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.mit;
  };
}
