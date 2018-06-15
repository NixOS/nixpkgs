{ stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "fastjet-${version}";
  version = "3.3.1";

  src = fetchurl {
    url = "http://fastjet.fr/repo/fastjet-${version}.tar.gz";
    sha256 = "0lvchyh9q2p8lb10isazw0wbwzs24yg7gxyhpj9xpvz5hydyvgvn";
  };

  buildInputs = [ python2 ];

  postPatch = ''
    substituteInPlace plugins/SISCone/SISConeBasePlugin.cc \
      --replace 'structure_of<UserScaleBase::StructureType>()' \
                'structure_of<UserScaleBase>()'
  '';

  configureFlags = [
    "--enable-allcxxplugins"
    "--enable-pyext"
    ];

  enableParallelBuilding = true;

  meta = {
    description = "A software package for jet finding in pp and e+e− collisions";
    license     = stdenv.lib.licenses.gpl2Plus;
    homepage    = http://fastjet.fr/;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
