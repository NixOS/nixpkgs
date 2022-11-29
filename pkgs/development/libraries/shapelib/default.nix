{ lib
, stdenv
, fetchurl
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "shapelib";
  version = "1.5.0";

  src = fetchurl {
    url = "https://download.osgeo.org/shapelib/shapelib-${version}.tar.gz";
    sha256 = "1qfsgb8b3yiqwvr6h9m81g6k9fjhfys70c22p7kzkbick20a9h0z";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-0699.patch";
      url = "https://github.com/OSGeo/shapelib/commit/c75b9281a5b9452d92e1682bdfe6019a13ed819f.patch";
      sha256 = "sha256-zJ7JHUtInA5q/RbkSs1DqVK+UQi2vIw2t1jqxocnQQI=";
    })
  ];

  doCheck = true;
  preCheck = ''
    patchShebangs tests contrib/tests
  '';

  meta = with lib; {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = "http://shapelib.maptools.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
  };
}
