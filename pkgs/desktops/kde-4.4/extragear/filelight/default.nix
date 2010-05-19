{stdenv, fetchurl, lib, cmake, qt4, perl, qimageblitz, kdelibs, kdebase_workspace,
automoc4, phonon}:

stdenv.mkDerivation {
  name = "filelight-1.9rc3";
  src = fetchurl {
    url = http://www.kde-apps.org/CONTENT/content-files/99561-filelight-1.9rc3.tgz;
    sha256 = "0ljyx23j4cvrsi1dvmxila82q2cd26barmcvc8qmr74kz6pj78sq";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon 
    qimageblitz ];
  meta = {
    description = "Shows disk usage as an interactive map of concentric rings";
    license = "GPL";
    homepage = http://www.methylblue.com/filelight/;
    maintainers = [ lib.maintainers.viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
