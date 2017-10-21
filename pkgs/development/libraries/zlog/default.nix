{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  version = "1.2.12";
  name = "zlog-${version}";

  src = fetchzip {
    name = "${name}-src";
    url = "https://github.com/HardySimpson/zlog/archive/${version}.tar.gz";
    sha256 = "1ychld0dcfdak2wnmkj941i0xav6ynlb3n6hz1kz03yy74ll2fqi";
  };

  configurePhase = ''
    sed -i 's;-Werror;;' src/makefile
  '';

  buildPhase = ''
    mkdir -p $out
    make PREFIX=$out
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    description= "Reliable, high-performance, thread safe, flexible, clear-model, pure C logging library";
    homepage = http://hardysimpson.github.com/zlog;
    license = licenses.lgpl21;
    platforms = platforms.linux; # cannot test on something else
    maintainers = [ maintainers.matthiasbeyer ];
  };

}
