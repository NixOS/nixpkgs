{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyston-autoload";
  version = "2.3.5";
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "pyton_autoload";
    sha256 = "0n1k83ww0pr4q6z0h7p8hvy21hcgb96jvgllfbwhvvyf37h3wlll";
    dist = "cp310";
    python = "cp310";
    platform = "manylinux2014_x86_64";
  };

  meta = with lib; {
    description = "Automatically loads and enables pyston";
    homepage = "https://www.github.com/pyston/pyston";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ onny ];
  };
}
