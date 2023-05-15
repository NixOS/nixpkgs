{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libvshadow-python";

  version = "20221030";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-U9cwm8Nye9eDb77FkB39U3fBMqn1jCEqpbizcXZCLQg=";
  };

  meta = with lib; {
    description = "Python bindings module for libvshadow";
    downloadPage = "https://github.com/libyal/libvshadow/releases";
    homepage = "https://github.com/libyal/libvshadow/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
