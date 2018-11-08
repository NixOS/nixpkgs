{ stdenv, fetchFromGitHub, buildDunePackage, alcotest }:

buildDunePackage rec {
  pname = "faraday";
  version = "0.5.0";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "1kql0il1frsbx6rvwqd7ahi4m14ik6la5an6c2w4x7k00ndm4d7n";
  };

  buildInputs = [ alcotest ];
  doCheck = true;

  meta = {
    description = "Serialization library built for speed and memory efficiency";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
