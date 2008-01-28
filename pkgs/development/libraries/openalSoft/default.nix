args: with args;
stdenv.mkDerivation {
#The current release is still in a testing phase, though it should be stable
# (neither the ABI or API will break). Please try it out and let me know how it
#  works. :-)

  name = "openal-soft-testing";

  src = fetchurl {
    url = http://kcat.strangesoft.net/OpenAL.tar.bz2;
    sha256 = "7b53c3e6eda1a71010651eb058c71c9b0c86b3c15cae5f0ffeeb7222531aa97d";
  };

  buildInputs = [cmake alsaLib];
  
  meta = {
      description = "openal alternative";
      homepage = http://kcat.strangesoft.net/openal.html;
      license = "GPL2";
  };
}
