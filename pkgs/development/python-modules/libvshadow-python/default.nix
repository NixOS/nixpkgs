{ buildPythonPackage, fetchPypi, lib, zlib }:
buildPythonPackage rec {
  pname = "libvshadow-python";
  name = pname;
  version = "20221030";

  meta = with lib; {
    description = "Python bindings module for libvshadow";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvshadow/";
    downloadPage = "https://github.com/libyal/libvshadow/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-U9cwm8Nye9eDb77FkB39U3fBMqn1jCEqpbizcXZCLQg=";
  };
}
