{ lib
, fetchPypi
, buildPythonPackage
, six
, nose
}:
buildPythonPackage rec {
  pname = "intbitset";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44bca80b8cc702d5a56f0686f2bb5e028ab4d0c2c1761941589d46b7fa2c701c";
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
