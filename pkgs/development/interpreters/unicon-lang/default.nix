{ lib, stdenv, fetchurl, unzip, libX11, libXt, libnsl }:

stdenv.mkDerivation {
  pname = "unicon-lang";
  version = "11.7";
  src = fetchurl {
    url = "http://unicon.org/dist/uni-2-4-2010.zip";
    sha256 = "1g9l2dfp99dqih2ir2limqfjgagh3v9aqly6x0l3qavx3qkkwf61";
  };
  nativeBuildInputs = [ unzip ];
  buildInputs = [ libnsl libX11 libXt ];

  hardeningDisable = [ "fortify" ];

  sourceRoot = ".";

  configurePhase = ''
    case "$(uname -a | sed 's/ /_/g')" in
    Darwin*Version_9*i386) sys=intel_macos;;
    Linux*x86_64*) sys=amd64_linux;;
    Linux*i686*) sys=intel_linux;;
    *) sys=unknown;;
    esac
    echo "all: ; echo" >  uni/3d/makefile
    make X-Configure name=$sys
  '';

  buildPhase = ''
    make Unicon
  '';

  installPhase = ''
    mkdir -p $out/
    cp -r bin $out/
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A very high level, goal-directed, object-oriented, general purpose applications language";
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.linux;
    license = licenses.gpl2;
    homepage = "http://unicon.org";
  };
}
