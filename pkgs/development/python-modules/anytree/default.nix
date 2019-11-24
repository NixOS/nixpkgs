{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, fetchpatch
, nose
, six
, graphviz
, fontconfig
}:

buildPythonPackage rec {
  pname = "anytree";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "c0fec0de";
    repo = pname;
    rev = version;
    sha256 = "0ag5ir9h5p7rbm2pmpxlkflwigrm7z4afh24jvbhqj7pyrbjmk9w";
  };

  patches = [
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

  # Fontconfig error: Cannot load default config file
  preCheck = ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

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
