{ buildPythonPackage, fetchPypi , python , stdenv, requests }:

buildPythonPackage rec {
  pname = "pylibgen";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16hj4x1j490w0wnrqv1la0jlbywiv3fx7ps62i008djbampc9li9";
  };

  propagatedBuildInputs = [
    requests
  ];

  meta = {
    homepage    = "https://github.com/JoshuaRLi/pylibgen";
    description = "Programmatic Python interface for Library Genesis";
    license     = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}


