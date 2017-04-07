{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "range-v3-${version}";
  version = "2017-01-30";

  src = fetchFromGitHub {
    owner = "ericniebler";
    repo = "range-v3";
    rev = "bab29767cce120e11872d79a2537bc6f0be76963";
    sha256 = "0kncpxms3f0nmn6jppp484244xq15d9298g3h3nlm1wvq8ib1jhi";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/include
    mv include/ $out/
  '';

  meta = with stdenv.lib; {
    description = "Experimental range library for C++11/14/17";
    homepage = https://github.com/ericniebler/range-v3;
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ xwvvvvwx ];
  };
}
