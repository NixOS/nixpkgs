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
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "c0fec0de";
    repo = pname;
    rev = version;
    sha256 = "1k3yj9h3ssjlz57r4g1qzxvprxjp7n92vms9fv0d46pigylxm5i3";
  };

  patches = [
    (substituteAll {
      src = ./graphviz.patch;
      inherit graphviz;
    })
    # Fix tests python3.7
    # See: https://github.com/c0fec0de/anytree/pull/85
    (fetchpatch {
      url = "https://github.com/c0fec0de/anytree/commit/dd1b3d325546fef7436711e4cfea9a5fb61daaf8.patch";
      sha256 = "1dpa2jh2kakfaapnqrz03frb67q5fwxzc8c70i6nv1b01i9xw0bn";
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
