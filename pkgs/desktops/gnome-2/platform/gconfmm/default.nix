{ stdenv, fetchurlGnome, pkgconfig, GConf, gtkmm, glibmm }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurlGnome {
    project = "gconfmm";
    major = "2"; minor = "28"; patchlevel = "3"; extension = "bz2";
    sha256 = "a5e0092bb73371a3ca76b2ecae794778f3a9409056fee9b28ec1db072d8e6108";
  };

  nativeBuildInputs = [pkgconfig];

  propagatedBuildInputs = [ GConf gtkmm glibmm ];

  meta = {
    description = "C++ wrappers for GConf";

    license = stdenv.lib.licenses.lgpl2Plus;

    platforms = stdenv.lib.platforms.linux;
  };
}
