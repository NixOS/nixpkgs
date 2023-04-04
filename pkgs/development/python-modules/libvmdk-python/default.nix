{ buildPythonPackage, fetchPypi, lib, zlib }:
buildPythonPackage rec {
  pname = "libvmdk-python";
  name = pname;
  version = "20221124";

  meta = with lib; {
    description = "Python bindings module for libvmdk";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvmdk/";
    downloadPage = "https://github.com/libyal/libvmdk/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gUgogP/ccPfO5auRKEd5Q5B0GrRIleLt+By3LXiOYXo=";
  };
}
