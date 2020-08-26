{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  pname = "ctemplate";

  version = "2.3";

  src = fetchurl {
    url = "https://github.com/OlafvdSpek/ctemplate/archive/ctemplate-${version}.tar.gz";
    sha256 = "0mi5g2xlws10z1g4x0cj6kd1r673kkav35pgzyqxa1w47xnwprcr";
  };

  buildInputs = [ python2 ];

  postPatch = ''
    patchShebangs .
  '';

  meta = {
    description = "A simple but powerful template language for C++";
    longDescription = ''
      CTemplate is a simple but powerful template language for C++. It
      emphasizes separating logic from presentation: it is impossible to
      embed application logic in this template language.
    '';
    homepage = "https://github.com/OlafvdSpek/ctemplate";
    license = stdenv.lib.licenses.bsd3;
  };
}
