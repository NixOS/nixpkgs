{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "glad";
  version = "0.1.36";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-P7ANv+x65t2+ugTiFUf2fzzPx5X8NFYkUM8/K7Gf28c=";
  };

  meta = with lib; {
    description = "Multi-Language Vulkan/GL/GLES/EGL/GLX/WGL Loader-Generator based on the official specs";
    homepage = "https://github.com/Dav1dde/glad";
    license = licenses.mit;
    maintainers = with maintainers; [ superherointj ];
  };
}
