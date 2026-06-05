{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "talkfilters";
  version = "2.3.8";

  src = fetchurl {
    url = "http://www.hyperrealm.com/talkfilters/talkfilters-${finalAttrs.version}.tar.gz";
    sha256 = "19nc5vq4bnkjvhk8srqddzhcs93jyvpm9r6lzjzwc1mgf08yg0a6";
  };

  hardeningDisable = [ "format" ];

  meta = {
    description = "Converts English text into text that mimics a stereotyped or humorous dialect";
    homepage = "https://www.hyperrealm.com/talkfilters/talkfilters.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ikervagyok ];
    platforms = with lib.platforms; unix;
  };
})
