{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  meta = {
    description = "A simple but powerful template language for C++";
    longDescription = ''
      CTemplate is a simple but powerful template language for C++. It
      emphasizes separating logic from presentation: it is impossible to
      embed application logic in this template language.  '';
    homepage = http://code.google.com/p/google-ctemplate/;
    license = "bsd";
  };

  pname = "ctemplate";
  version = "0.97";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://google-ctemplate.googlecode.com/files/${name}.tar.gz";
    sha256 = "0p588zjf7gyi06rcggh9ljx2bj5250zi7s8y3vxmg3j9vddhkdyx";
  };
}
