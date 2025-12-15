{
  buildPythonPackage,
  lib,
  fetchPypi,
  click,
  six,
  tqdm,
  joblib,
  pytest,
}:

buildPythonPackage rec {
  pname = "sacremoses";
  version = "0.0.35";
  format = "setuptools";

  # pypi does not include tests
  # new source is https://github.com/hplt-project/sacremoses
  # but lacks release 0.0.35
  src = fetchPypi {
    inherit version;
    pname = "sacremoses";
    hash = "sha256-HoTalcvb/Iu8FIwP61pHN8XZdXBxt56MESnkSUEOQQo=";
  };

  propagatedBuildInputs = [
    click
    six
    tqdm
    joblib
  ];

  doInstallCheck = false;

  meta = {
    homepage = "https://github.com/hplt-project/sacremoses";
    description = "Python port of Moses tokenizer, truecaser and normalizer";
    mainProgram = "sacremoses";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pashashocky ];
  };
}
