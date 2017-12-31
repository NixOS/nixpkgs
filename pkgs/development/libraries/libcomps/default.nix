{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, libxml2
, expat
, python
, check
}:

let
  pname = "libcomps";
  version = "0.1.8";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "rpm-software-management";
    repo   = pname;
    rev    = name;
    sha256 = "0nn9q8hpjcwwrnyf0j6mfkw7rvd7ynbndy18nscn108aqr7nv81l";
  };

  patches = [
    ./0001-Python-respect-CMAKE_INSTALL_PREFIX.patch
  ];

  patchFlags = ["-p2"]; # Because of sourceRoot

  sourceRoot = "${src.name}/${pname}";

  cmakeFlags="-DPYTHON_DESIRED=${stdenv.lib.substring 0 1 python.pythonVersion}";

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libxml2 expat python check ];

  meta = with stdenv.lib; {
    description = "Libcomps is alternative for yum.comps library";
    homepage = https://github.com/rpm-software-management/libcomps;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
