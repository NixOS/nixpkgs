{ buildPythonPackage, fetchPypi, lib, zlib }:

buildPythonPackage rec {
  pname = "libvmdk-python";

  version = "20221124";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gUgogP/ccPfO5auRKEd5Q5B0GrRIleLt+By3LXiOYXo=";
  };

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Python bindings module for libvmdk";
    downloadPage = "https://github.com/libyal/libvmdk/releases";
    homepage = "https://github.com/libyal/libvmdk/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
