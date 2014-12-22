{ stdenv, fetchsvn, python }:

stdenv.mkDerivation rec {
  name = "ctemplate-${version}";

  version = "2.3";

  src = fetchsvn {
    url = "http://ctemplate.googlecode.com/svn/tags/${name}";
    sha256 = "1kvh82mhazf4qz7blnv0rcax7vi524dmz6v6rp89z2h3qjilbvc7";
  };

  buildInputs = [ python ];

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
    homepage = http://code.google.com/p/google-ctemplate/;
    license = "bsd";
  };
}
