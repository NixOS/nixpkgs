{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation rec {
  name = "pony-stable-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "pony-stable";
    rev = version;
    sha256 = "0zzcq0vsl6kcrsxwqzd3s9mq7aq5sg8si5c83rxyi9n6a06gnbh7";
  };

  buildInputs = [ ponyc ];

  installFlags = [ "prefix=${placeholder "out"}" "install" ];

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = https://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ dipinhora kamilchm patternspandemic ];
    platforms = stdenv.lib.platforms.unix;
  };
}
