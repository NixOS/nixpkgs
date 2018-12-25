{ stdenv, fetchFromGitHub, buildDunePackage, alcotest }:

buildDunePackage rec {
  pname = "bigstringaf";
  version = "0.3.0";

  minimumOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    rev = version;
    sha256 = "1yx6hv8rk0ldz1h6kk00rwg8abpfc376z00aifl9f5rn7xavpscs";
  };

  buildInputs = [ alcotest ];
  doCheck = true;

  meta = {
    description = "Bigstring intrinsics and fast blits based on memcpy/memmove";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
