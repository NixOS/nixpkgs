{ lib, fetchFromGitHub, buildPythonPackage, nose }:

buildPythonPackage rec {
  pname = "rx";
  version = "1.6.0";

  # There are no tests on the pypi source
  src = fetchFromGitHub {
    owner = "ReactiveX";
    repo = "rxpy";
    rev = version;
    sha256 = "174xi2j36igxmaqcgl5p64p31a7z19v62xb5czybjw72gpyyfyri";
  };

  checkInputs = [ nose ];

  meta = {
    homepage = https://github.com/ReactiveX/RxPY;
    description = "Reactive Extensions for Python";
    maintainers = with lib.maintainers; [ thanegill ];
    license = lib.licenses.asl20;
  };
}
