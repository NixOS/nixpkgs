{stdenv, fetchurl}:

let
  pname = "scsh";
  version = "0.6.7";
  name = "${pname}-${version}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "c4a9f7df2a0bb7a7aa3dafc918aa9e9a566d4ad33a55f0192889de172d1ddb7f";
  };

  meta = {
    description = "a Scheme shell";
    longDescription = ''
      SCSH is an implementation of the Scheme shell.  It is implemented as
      a heap image which is interpreted by the Scheme 48 virtual machine.
    '';
    homepage = http://www.scsh.net/;
    license = "BSD";
  };
}
