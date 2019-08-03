{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ecos-${version}";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "embotech";
    repo = "ecos";
    rev = "v${version}";
    sha256 = "11v958j66wq30gxpjpkgl7n3rvla845lygz8fl39pgf1vk9sdyc7";
  };

  buildPhase = ''
    make all shared
  '';

  doCheck = true;
  checkPhase = ''
    make test
    ./runecos
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp lib*.a lib*.so $out/lib
    cp -r include $out/
  '';

  meta = with stdenv.lib; {
    description = "A lightweight conic solver for second-order cone programming";
    homepage = https://www.embotech.com/ECOS;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.bhipple ];
  };
}
