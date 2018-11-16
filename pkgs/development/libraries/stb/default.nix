{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "stb-${version}";
  version = "20180211";

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "e6afb9cbae4064da8c3e69af3ff5c4629579c1d2";
    sha256 = "079nsn9bnb8c0vfq26g5l53q6gzx19a5x9q2nb55mpcljxsgxnmf";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include/stb
    cp *.h $out/include/stb/
  '';

  meta = with stdenv.lib; {
    description = "Single-file public domain libraries for C/C++";
    homepage = https://github.com/nothings/stb;
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
