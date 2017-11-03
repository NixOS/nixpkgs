{ stdenv, buildPythonPackage, fetchurl, pytest, mock }:
buildPythonPackage rec {
  pname = "pep257";
  name = "${pname}-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/GreenSteam/pep257/archive/${version}.tar.gz";
    sha256 = "1ldpgil0kaf6wz5gvl9xdx35a62vc6bmgi3wbh9320dj5v2qk4wh";
  };

  buildInputs = [ pytest mock ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/GreenSteam/pep257/;
    description = "Python docstring style checker";
    longDescription = "Static analysis tool for checking compliance with Python PEP 257.";
    license = licenses.mit;
  };
}
