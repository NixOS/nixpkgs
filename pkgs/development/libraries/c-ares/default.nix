{ stdenv, fetchurl, writeTextDir }:

let self =
stdenv.mkDerivation rec {
  name = "c-ares-1.13.0";

  src = fetchurl {
    url = "http://c-ares.haxx.se/download/${name}.tar.gz";
    sha256 = "19qxhv9aiw903fr808y77r6l9js0fq9m3gcaqckan9jan7qhixq3";
  };

  meta = with stdenv.lib; {
    description = "A C library for asynchronous DNS requests";
    homepage = https://c-ares.haxx.se;
    license = licenses.mit;
    platforms = platforms.all;
  };

  # Adapted from running a cmake build
  passthru.cmake-config = writeTextDir "c-ares-config.cmake"
    ''
      set(c-ares_INCLUDE_DIR "${self}/include")

      set(c-ares_LIBRARY c-ares::cares)

      add_library(c-ares::cares SHARED IMPORTED)

      set_target_properties(c-ares::cares PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${self}/include"
        INTERFACE_LINK_LIBRARIES "nsl;rt"
      )
      set_property(TARGET c-ares::cares APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(c-ares::cares PROPERTIES
        IMPORTED_LOCATION_RELEASE "${self}/lib/libcares.so.2.2.0"
        IMPORTED_SONAME_RELEASE "libcares.so.2"
        )
      add_library(c-ares::cares_shared INTERFACE IMPORTED)
      set_target_properties(c-ares::cares_shared PROPERTIES INTERFACE_LINK_LIBRARIES "c-ares::cares")
      set(c-ares_SHARED_LIBRARY c-ares::cares_shared)
    '';

}; in self
