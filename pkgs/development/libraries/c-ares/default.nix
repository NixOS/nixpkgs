{ stdenv, fetchurl, writeTextDir }:

let self =
stdenv.mkDerivation rec {
  name = "c-ares-1.14.0";

  src = fetchurl {
    url = "https://c-ares.haxx.se/download/${name}.tar.gz";
    sha256 = "0vnwmbvymw677k780kpb6sb8i3szdp89rzy8mz1fwg1657yw3ls5";
  };

  # ares_android.h header is missing
  # see issue https://github.com/c-ares/c-ares/issues/216
  postPatch = if stdenv.hostPlatform.isAndroid then ''
    cp ${fetchurl {
      url = "https://raw.githubusercontent.com/c-ares/c-ares/cares-1_14_0/ares_android.h";
      sha256 = "1aw8y6r5c8zq6grjwf4mcm2jj35r5kgdklrp296214s1f1827ps8";
    }} ares_android.h
  '' else null;

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
        ${stdenv.lib.optionalString stdenv.isLinux ''INTERFACE_LINK_LIBRARIES "nsl;rt"''}
      )
      set_property(TARGET c-ares::cares APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(c-ares::cares PROPERTIES
        IMPORTED_LOCATION_RELEASE "${self}/lib/libcares${stdenv.targetPlatform.extensions.sharedLibrary}"
        IMPORTED_SONAME_RELEASE "libcares${stdenv.targetPlatform.extensions.sharedLibrary}"
        )
      add_library(c-ares::cares_shared INTERFACE IMPORTED)
      set_target_properties(c-ares::cares_shared PROPERTIES INTERFACE_LINK_LIBRARIES "c-ares::cares")
      set(c-ares_SHARED_LIBRARY c-ares::cares_shared)
    '';

}; in self
