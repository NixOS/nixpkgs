{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  glibmm,
  perl,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "libxml++";
  version = "2.40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1sb3akryklvh2v6m6dihdnbpf1lkx441v972q9hlz1sq6bfspm2a";
  };

  configureFlags = [
    # remove if library is updated
    "CXXFLAGS=-std=c++11"
  ];

  outputs = [
    "out"
    "devdoc"
  ];

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  propagatedBuildInputs = [
    libxml2
    glibmm
  ];

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "libxmlxx";
      packageName = pname;
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    homepage = "https://libxmlplusplus.sourceforge.net/";
    description = "C++ wrapper for the libxml2 XML parser library";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
