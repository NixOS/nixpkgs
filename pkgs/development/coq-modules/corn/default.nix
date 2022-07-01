{ lib, mkCoqDerivation, coq, bignums, math-classes, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "corn";
  inherit version;
  defaultVersion = switch coq.coq-version [
    { case = "8.6"; out = "8.8.1"; }
    { case = (versions.range "8.7" "8.15"); out = "8.13.0"; }
  ] null;
  release = {
    "8.8.1".sha256 = "0gh32j0f18vv5lmf6nb87nr5450w6ai06rhrnvlx2wwi79gv10wp";
    "8.12.0".sha256 = "0b92vhyzn1j6cs84z2182fn82hxxj0bqq7hk6cs4awwb3vc7dkhi";
    "8.13.0".sha256 = "1wzr7mdsnf1rq7q0dvmv55vxzysy85b00ahwbs868bl7m8fk8x5b";
  };

  preConfigure = "patchShebangs ./configure.sh";
  configureScript = "./configure.sh";
  dontAddPrefix = true;

  propagatedBuildInputs = [ bignums math-classes ];

  meta = {
    homepage = "http://c-corn.github.io/";
    license = licenses.gpl2;
    description = "A Coq library for constructive analysis";
    maintainers = [ maintainers.vbgl ];
  };
}
