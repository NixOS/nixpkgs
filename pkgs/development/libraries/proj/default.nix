{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "proj-4.8.0";

  src = fetchurl {
    url = http://download.osgeo.org/proj/proj-4.8.0.tar.gz;
    sha256 = "1dfim63ks298204lv2z0v16njz6fs7bf0m4icy09i3ffzvqdpcid";
  };

  postConfigure = ''
    patch src/Makefile <<EOF
    272c272
    < include_HEADERS = proj_api.h org_proj4_Projections.h
    ---
    > include_HEADERS = proj_api.h org_proj4_Projections.h projects.h
    EOF
  '';

  meta = with stdenv.lib; {
    description = "Cartographic Projections Library";
    homepage = http://trac.osgeo.org/proj/;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
