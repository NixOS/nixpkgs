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
  version = "2.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ctemplate.googlecode.com/files/${name}.tar.gz";
    sha256 = "0scdqqbp8fy9jiak60dj1051gbyb8xmlm4rdz4h1myxifjagwbfa";
  };
}
