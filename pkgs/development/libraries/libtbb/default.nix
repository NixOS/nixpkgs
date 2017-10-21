{ stdenv, fetchFromGitHub, tree }: 

stdenv.mkDerivation rec {
  name = "libtbb-${version}";
  version = "2018_U1";

  src = fetchFromGitHub {
    owner = "01org";
    repo = "tbb";
    rev = "${version}";
    sha256 = "1lygz07va6hsv2vlx9zwz5d2n81rxsdhmh0pqxgj8n1bvb1rp0qw";
  };

  buildInputs = [ tree ];

  installPhase = ''
    mkdir -p "$out"/usr/include "$out"/lib
    install -m755 build/linux_*/*.so* "$out"/lib/
    cp -a include/tbb "$out"/usr/include/
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.threadingbuildingblocks.org/";
    description = "High level abstract threading library";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ dizfer ];
  };
}

