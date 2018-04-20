{ buildPythonPackage
, fetchPypi
, lib
, attrs
, six
}:
let

version = "0.11.0";
pname = "effect";

in
buildPythonPackage {
  inherit version pname;                      
  src = fetchPypi {
    inherit pname version;
    sha256 = "1q75w4magkqd8ggabhhzzxmxakpdnn0vdg7ygj89zdc9yl7561q6";
  };
  propagatedBuildInputs = [
    six
    attrs
  ];
  doCheck = false;
  meta = with lib; {
    description = "pure effects for Python";
    homepage = https://github.com/python-effect/effect;
    license = licenses.mit;
  };
}
