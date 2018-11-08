{ stdenv, fetchFromGitHub, buildDunePackage, easy-format }:

buildDunePackage rec {
  pname = "biniou";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mjpgwyfq2b2izjw0flmlpvdjgqpq8shs89hxj1np2r50csr8dcb";
  };

  propagatedBuildInputs = [ easy-format ];

  postPatch = ''
   patchShebangs .
  '';

  meta = {
    inherit (src.meta) homepage;
    description = "Binary data format designed for speed, safety, ease of use and backward compatibility as protocols evolve";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.bsd3;
  };
}
