{ lib, mkCoqDerivation, coq, bignums, math-classes, version ? null }:

mkCoqDerivation rec {
  pname = "corn";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = (range "8.17" "8.20"); out = "8.19.0"; }
    { case = (range "8.14" "8.18"); out = "8.18.0"; }
    { case = (range "8.11" "8.17"); out = "8.16.0"; }
    { case = (range "8.7"  "8.15"); out = "8.13.0"; }
    { case = "8.6"; out = "8.8.1"; }
  ] null;
  release = {
    "8.8.1".sha256 = "0gh32j0f18vv5lmf6nb87nr5450w6ai06rhrnvlx2wwi79gv10wp";
    "8.12.0".sha256 = "0b92vhyzn1j6cs84z2182fn82hxxj0bqq7hk6cs4awwb3vc7dkhi";
    "8.13.0".sha256 = "1wzr7mdsnf1rq7q0dvmv55vxzysy85b00ahwbs868bl7m8fk8x5b";
    "8.16.0".sha256 = "sha256-ZE/EEIndxHfo/9Me5NX4ZfcH0ZAQ4sRfZY7LRZfLXBQ=";
    "8.18.0".sha256 = "sha256-ow3mfarZ1PvBGf5WLnI8LdF3E+8A6fN7cOcXHrZJLo0=";
    "8.19.0".sha256 = "sha256-h5MlfRuv2hTbxGmpLUEGQO1YqQTwUNEHZzCfvdOU1TA=";
  };

  configureScript = "./configure.sh";
  dontAddPrefix = true;

  propagatedBuildInputs = [ bignums math-classes ];

  meta =  with lib; {
    homepage = "http://c-corn.github.io/";
    license = licenses.gpl2;
    description = "Coq library for constructive analysis";
    maintainers = [ maintainers.vbgl ];
  };
}
