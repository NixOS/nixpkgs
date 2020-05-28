{ lib
, buildPythonPackage
, fetchPypi
, graphviz
, jinja2
, isPy27
, python
}:

buildPythonPackage rec {
  pname = "diagrams";
  version = "0.12.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8cfc6554c79c9dc2372f144a857819e0ef982082cb690b0ac22c255e5177ee4a";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "'graphviz>=0.13.2,<0.14.0'" "'graphviz'"
  '';

  propagatedBuildInputs = [
    graphviz
    jinja2
  ];

  # add image resources to build
  postInstall = ''
    cp -r resources $out/${python.sitePackages}/
  '';

  # tests not included with PyPi Release
  doCheck = false;

  meta = with lib; {
    description = "Diagram as Code";
    homepage = "https://diagrams.mingrammer.com";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
