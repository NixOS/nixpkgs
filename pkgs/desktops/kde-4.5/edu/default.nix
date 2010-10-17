{ kde, cmake, qt4, perl, libxml2, libxslt, openbabel, boost, readline, gmm, gsl
, xplanet, libspectre, pkgconfig, libqalculate
, kdelibs, automoc4, eigen, attica}:

kde.package {

#TODO:
#* Boost.Python (1.31 or higher)  <http://www.boost.org/> - fails to find
# * libcfitsio0 (3.09 or higher)  <http://indi.sf.net>
# * libindi (0.6.1 or higher)  <http://indi.sf.net>
# * R  <http://www.r-project.org/>
# * OCaml  <http://caml.inria.fr/>
# * LibFacile  <http://www.recherche.enac.fr/log/facile/>
# * Avogadro (1.0 or higher)  <http://avogadro.openmolecules.net>
# * libgps

  buildInputs = [ cmake qt4 perl libxml2 libxslt openbabel boost readline gmm
    gsl xplanet kdelibs automoc4 eigen attica libspectre pkgconfig
    libqalculate ];

  meta = {
    description = "KDE Educative software";
    license = "GPL";
    kde = {
      name = "kdeedu";
      version = "4.5.2";
    };
  };
}
