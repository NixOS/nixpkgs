args: with args;

stdenv.mkDerivation {
  name = "kdepimlibs-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdepimlibs-3.97.0.tar.bz2;
	sha256 = "1zv4l592288bdfxqllm8z1cmsjcprfji5harcxf9hhz95igp5n7j";
  };

  propagatedBuildInputs = [kdelibs boost gpgme cyrus_sasl openldap];
}
