{ stdenv
, fetchFromGitHub
, zlib
}:

let
  version = "0.9";
  tag = "v${version}";
  rev = "15773561e40ca5c8cffe0a618c544b6cfdc5ad7e";
in

stdenv.mkDerivation {
  inherit version;
  pname = "mrustc";

  src = fetchFromGitHub {
    owner = "thepowersgang";
    repo = "mrustc";
    rev = tag;
    sha256 = "194ny7vsks5ygiw7d8yxjmp1qwigd71ilchis6xjl6bb2sj97rd2";
  };

  postPatch = ''
    sed -i 's/\$(shell git show --pretty=%H -s)/${rev}/' Makefile
    sed -i 's/\$(shell git symbolic-ref -q --short HEAD || git describe --tags --exact-match)/${tag}/' Makefile
    sed -i 's/\$(shell git diff-index --quiet HEAD; echo $$?)/0/' Makefile
  '';

  buildInputs = [ stdenv zlib ];
  buildPhase = "make -j $NIX_BUILD_CORES";

  installPhase = ''
    mkdir -p $out/bin
    cp bin/mrustc $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Mutabah's Rust Compiler";
    longDescription = ''
      In-progress alternative rust compiler, written in C++.
      Capable of building a fully-working copy of rustc,
      but not yet suitable for everyday use.
    '';
    homepage = "https://github.com/thepowersgang/mrustc";
    license = licenses.mit;
    maintainers = [ maintainers.progval ];
    platforms = platforms.all;
  };
}
