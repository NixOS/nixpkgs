{ lib, stdenv
, fetchFromGitHub
, sphinxbase
, pkg-config
, python3
, swig2 # 2.0
, autoreconfHook
}:

stdenv.mkDerivation {
  pname = "pocketsphinx";
  version = "unstable-2022-02-22";

  src = fetchFromGitHub {
    owner = "cmusphinx";
    repo = "pocketsphinx";
    rev = "5da71f0a05350c923676b02a69423d1291825d5b";
    hash = "sha256-YZwuVYg8Uqt1gOYXeYC8laRj+IObbuO9f/BjcQKRwkY=";
  };

  propagatedBuildInputs = [ sphinxbase ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ python3 swig2 ];

  preBuild = "gcc --version";

  meta = {
    description = "Voice recognition library written in C";
    homepage = "https://cmusphinx.github.io";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
  };
}

/* Example usage:


1.

$ cat << EOF > vocabulary.txt
oh mighty computer /1e-40/
hello world /1e-30/
EOF

2.

$ pocketsphinx_continuous -inmic yes -kws vocabulary.txt 2> /dev/null
# after you say "hello world":
hello world
...

*/
