{ lib
, buildPythonPackage
, fetchPypi
, substituteAll
, fetchpatch
, nose
, six
, withGraphviz ? true
, graphviz
, fontconfig
}:

buildPythonPackage rec {
  pname = "anytree";
  version = "2.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05736hamjv4f38jw6z9y4wckc7mz18ivbizm1s3pb0n6fp1sy4zk";
  };

  patches = lib.optionals withGraphviz [
    (substituteAll {
      src = ./graphviz.patch;
      inherit graphviz;
    })
  ];

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    six
  ];

  # tests print “Fontconfig error: Cannot load default config file”
  preCheck = lib.optionalString withGraphviz ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

  # circular dependency anytree → graphviz → pango → glib → gtk-doc → anytree
  doCheck = withGraphviz;

  checkPhase = ''
    runHook preCheck

    nosetests

    runHook postCheck
  '';

  meta = with lib; {
    description = "Powerful and Lightweight Python Tree Data Structure";
    homepage = https://github.com/c0fec0de/anytree;
    license = licenses.asl20;
    maintainers = [ maintainers.worldofpeace ];
  };
}
