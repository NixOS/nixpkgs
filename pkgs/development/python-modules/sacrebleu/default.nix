{ lib
, buildPythonPackage
, fetchPypi

# Propagated build inputs
, portalocker
, regex
, tabulate
, numpy
, colorama

# Check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sacrebleu";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:0jxq311kkszpqm58bl043rcczdxjfqwwxyw313pxfpf45q6ly678";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "portalocker==" "portalocker>="
  '';

  propagatedBuildInputs = [
    portalocker
    regex
    tabulate
    numpy
    colorama
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # all api tests require network access
    "test/test_api.py"
  ];

  pythonImportsCheck = [ "sacrebleu" ];

  meta = with lib; {
    description = "Hassle-free computation of shareable, comparable, and reproducible BLEU, chrF, and TER scores";
    homepage = "https://github.com/mjpost/sacrebleu";
    changelog = "https://github.com/mjpost/sacrebleu/blob/v{version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
