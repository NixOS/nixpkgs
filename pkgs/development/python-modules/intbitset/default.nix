{ lib
, fetchFromGitHub
, buildPythonPackage
, six
, nose
}:
buildPythonPackage rec {
  pname = "intbitset";
  version = "2.4.1";

  src = fetchFromGitHub {
     owner = "inveniosoftware";
     repo = "intbitset";
     rev = "v2.4.1";
     sha256 = "1bl0w2mv92qv5xml19mzlypghz0dk8br3bqnpwp34gx3af8a2s7d";
  };

  patches = [
    # fixes compilation on aarch64 and determinism (uses -march=core2 and
    # -mtune=native)
    ./remove-impure-tuning.patch
  ];

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    nose
  ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "intbitset"
  ];

  meta = with lib; {
    description = "C-based extension implementing fast integer bit sets";
    homepage = "https://github.com/inveniosoftware/intbitset";
    license = licenses.lgpl3Only;
    maintainers = teams.determinatesystems.members;
  };
}
