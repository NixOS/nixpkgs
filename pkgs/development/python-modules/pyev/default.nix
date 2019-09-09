{ stdenv, fetchurl, buildPythonPackage, libev }:

buildPythonPackage rec {
  pname = "pyev";
  version = "0.9.0";

  src = fetchurl {
    url = "mirror://pypi/p/pyev/${pname}-${version}.tar.gz";
    sha256 = "0rf603lc0s6zpa1nb25vhd8g4y337wg2wyz56i0agsdh7jchl0sx";
  };

  buildInputs = [ libev ];

  libEvSharedLibrary =
    if !stdenv.isDarwin
    then "${libev}/lib/libev.so.4"
    else "${libev}/lib/libev.4.dylib";

  postPatch = ''
    test -f "${libEvSharedLibrary}" || { echo "ERROR: File ${libEvSharedLibrary} does not exist, please fix nix expression for pyev"; exit 1; }
    sed -i -e "s|libev_dll_name = find_library(\"ev\")|libev_dll_name = \"${libEvSharedLibrary}\"|" setup.py
  '';

  meta = with stdenv.lib; {
    description = "Python bindings for libev";
    homepage = https://code.google.com/p/pyev/;
    license = licenses.gpl3;
    maintainers = [ maintainers.bjornfor ];
  };
}
