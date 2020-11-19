{ stdenv, buildPythonPackage, fetchPypi
, tornado_5, pyyaml, funcparserlib
, nixosTests
}:

buildPythonPackage rec {
  pname = "graphite_beacon";
  version = "0.27.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03bp4wyfn3xhcqyvs5hnk1n87m4smsmm1p7qp459m7j8hwpbq2ks";
  };

  propagatedBuildInputs = [ tornado_5 pyyaml funcparserlib ];

  postPatch = ''
    substituteInPlace requirements.txt --replace "==" ">="
  '';

  pythonImportsCheck = [ "graphite_beacon" ];

  passthru.tests = {
    nixos = nixosTests.graphite;
  };

  meta = with stdenv.lib; {
    description = "A simple alerting application for Graphite metrics";
    homepage = "https://github.com/klen/graphite-beacon";
    maintainers = [ maintainers.offline ];
    license = licenses.mit;
  };
}
